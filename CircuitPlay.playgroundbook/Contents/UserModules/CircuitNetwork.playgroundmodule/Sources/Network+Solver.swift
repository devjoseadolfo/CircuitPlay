import Accelerate

extension CircuitNetwork {
    public var nodeCount: Int { nodes.count }
    public var voltageSourceCount: Int { models.filter{$0 is VoltageSourceModel || $0 is InductorModel}.count }
    
    public mutating func createBVector() {
        var values: [Double] = []
        
        var minusGroundNode = nodes
        minusGroundNode.removeFirst()
        
        for node in minusGroundNode {
            let currentSources = models
                .filter{ $0 is CurrentSourceModel }
                .filter{ model in
                    model.connectedNodes.contains { possNode in
                        possNode.value == node.number
                    }
                }
                .map {
                    $0 as! CurrentSourceModel
                }
            
            let capacitors = models
                .filter{ $0 is CapacitorModel }
                .filter{ model in
                    model.connectedNodes.contains { possNode in
                        possNode.value == node.number
                    }
                }
                .map {
                    $0 as! CapacitorModel
                }
            
            var current: Double = 0
            
            for source in currentSources {
                if source.positiveTerminalNode == node.number {
                    current += source.current
                } else if source.negativeTerminalNode == node.number {
                    current -= source.current
                }
            }
            
            for capacitor in capacitors {
                if capacitor.positiveTerminalNode == node.number {
                    current += capacitor.equivalentCurrent
                } else if capacitor.negativeTerminalNode == node.number {
                    current -= capacitor.equivalentCurrent
                }
            }
            
            values.append(current)
        }
        
        let voltageSources = models
            .filter{ $0 is VoltageSourceModel }
            .map { $0 as! VoltageSourceModel}
        
        for source in voltageSources {
            values.append(source.voltage)
        }
        
        let inductors = models
            .filter{ $0 is InductorModel }
            .map { $0 as! InductorModel}
        
        for inductor in inductors {
            values.append(inductor.equivalentVoltage)
        }
        
        bVector = values
    }
    
    public mutating func createXVector() {
        xVector = Array(repeating: 0, count: nodes.count + voltageSourceCount - 1)
    }
    
    public mutating func createConductanceMatrix() {
        var nodeVectors: [[Double]] = []
        
        var minusGroundNode = nodes
        minusGroundNode.removeFirst()
        
        var row: [Int32] = [Int32]()
        var column: [Int32] = [Int32]()
        var value: [Double] = [Double]()
        for i in 0..<minusGroundNode.count {
            for j in 0...i {
                let resistorModels = models
                    .filter { $0 is ResistorModel }
                    .filter{ model in
                        model.connectedNodes.contains { possNode in
                            possNode.value == i + 1
                        } }
                    .filter{ model in
                        model.connectedNodes.contains { possNode in
                            possNode.value == j + 1
                        } }
                
                let capacitorModels = models
                    .filter { $0 is CapacitorModel }
                    .filter{ model in
                        model.connectedNodes.contains { possNode in
                            possNode.value == i + 1
                        } }
                    .filter{ model in
                        model.connectedNodes.contains { possNode in
                            possNode.value == j + 1
                        } }
                
                var conductance: Double = 0
                
                for model in resistorModels {
                    let resistorModel = model as! ResistorModel
                    if i == j {
                        conductance += 1.00 / resistorModel.resistance
                    } else {
                        conductance -= 1.00 / resistorModel.resistance
                    }
                }
                
                for model in capacitorModels {
                    let capacitorModel = model as! CapacitorModel
                    if i == j {
                        conductance += 1.00 / capacitorModel.equivalentResistance
                    } else {
                        conductance -= 1.00 / capacitorModel.equivalentResistance
                    }
                }
                
                row.append(Int32(i))
                column.append(Int32(j))
                value.append(conductance)
            }
        }
        
        var voltageVectors: [[Double]] = []
        
        let voltageSources = models
            .filter{ $0 is VoltageSourceModel }
            .map { $0 as! VoltageSourceModel }
        
        let nodeCount = minusGroundNode.count
        
        for i in 0..<voltageSources.count {
            for j in 0..<minusGroundNode.count {
                // print(i,j)
                // print(voltageSources[i].positiveTerminalNode)
                // print(voltageSources[i].negativeTerminalNode)
                if voltageSources[i].positiveTerminalNode == j + 1 {
                    row.append(Int32(i + nodeCount))
                    column.append(Int32(j))
                    value.append(1)
                } else if voltageSources[i].negativeTerminalNode == j + 1 {
                    row.append(Int32(i + nodeCount))
                    column.append(Int32(j))
                    value.append(-1)
                }
            }
        }
        
        let inductorSources = models
            .filter{ $0 is InductorModel }
            .map { $0 as! InductorModel}
        
        let sourceCount = voltageSources.count
        
        for i in 0..<inductorSources.count {
            for j in 0..<minusGroundNode.count {
                if inductorSources[i].positiveTerminalNode == j + 1 {
                    row.append(Int32(i + nodeCount + sourceCount))
                    column.append(Int32(j))
                    value.append(1)
                } else if inductorSources[i].negativeTerminalNode == j + 1 {
                    row.append(Int32(i + nodeCount + sourceCount))
                    column.append(Int32(j))
                    value.append(-1)
                }
            }
            
            row.append(Int32(i + nodeCount + sourceCount))
            column.append(Int32(i + nodeCount + sourceCount))
            value.append(-inductorSources[i].equivalentResistance)
        }
        
        // print(row)
        // print(column)
        // print(value)
        values = value
        
        var attributes = SparseAttributes_t()
        attributes.triangle = SparseUpperTriangle
        attributes.kind = SparseSymmetric
        
        let blockCount = value.count
        let blockSize = 1
        let count: Int32 = Int32(nodeCount + sourceCount + inductorSources.count)
        
        conductanceMatrix = SparseConvertFromCoordinate(count, count,
                                            blockCount, UInt8(blockSize),
                                            attributes,
                                            &row, &column,
                                            &value)
    }
    
    public mutating func solveSparseMatrix() {
        guard let conductanceMatrix = conductanceMatrix else { return }
        
        let ldlt: SparseOpaqueFactorization_Double = SparseFactor(SparseFactorizationLDLT, conductanceMatrix)
        
        let count = bVector.count
        
        bVector.withUnsafeMutableBufferPointer { bPtr in
            xVector.withUnsafeMutableBufferPointer { xPtr in
                
                let b = DenseVector_Double(
                    count: Int32(count),
                    data: bPtr.baseAddress!
                )
                let x = DenseVector_Double(
                    count: Int32(count),
                    data: xPtr.baseAddress!
                )
                
                SparseSolve(ldlt, b, x)
            }
        }
        SparseCleanup(conductanceMatrix)
        SparseCleanup(ldlt)
    }
}

