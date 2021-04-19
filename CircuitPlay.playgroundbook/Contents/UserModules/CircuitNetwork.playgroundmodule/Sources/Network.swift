import CircuitKit
import Accelerate

public struct CircuitNetwork {
    public var circuit: Circuit
    
    public var timeStep: Double = 0.01
    public var step: Int = 0
    
    public var nodes: [Node] = [Node(0)]
    public var models: [Model] = []

    
    public var conductanceMatrix: SparseMatrix_Double?
    public var values: [Double] = []
    public var invertedConductanceMatrix: SparseMatrix_Double?
    public var xVector: [Double] = []
    public var bVector: [Double] = []
    
    public var groundCount: Int = 0
    
    public init(circuit: Circuit) {
        self.circuit = circuit
        // print("Making ground node")
        makeGroundNode()
        // print("Making rest of the network")
        makeNodesAndModels()
        // print("Assigning connections")
        assignConnections()
        makeHiddenNodes()
        // attachHiddenGroundNodes()
        assignInductorNodes()
    }
    
    public mutating func solveNetwork() {
        createConductanceMatrix()
        createBVector()
        createXVector()
        solveSparseMatrix()
        // print("b", bVector)
        // print("x", xVector)
        // multiplyInverseMatrixToVector()
        updateNodeVoltages()
        updateModelVoltage()
        updateModelCurrent()
    }
    
    public mutating func updateNodeVoltages() {
        for i in 1..<nodes.count {
            nodes[i].voltage = xVector[i - 1]
        }
    }
    
    public mutating func updateModelVoltage() {
        for i in 0..<models.count {
            let modelNodes = models[i].connectedNodes.map{ ($0.key, $0.value)}
            guard modelNodes.count > 0 else {
                continue
            }
            let firstNode = modelNodes[0]
            let secondNode = modelNodes[1]
            let firstVoltage = nodes[firstNode.1].voltage
            let secondVoltage = nodes[secondNode.1].voltage
            let voltageDifference = firstVoltage - secondVoltage
            models[i].voltage = abs(voltageDifference)
            
            if models[i] is CapacitorModel {
                var capacitor = models[i] as! CapacitorModel
                if voltageDifference > 0 {
                    capacitor.positiveTerminalNode = firstNode.1
                    capacitor.negativeTerminalNode = secondNode.1
                    capacitor.currentGoing = secondNode.0
                } else if voltageDifference < 0 {
                    capacitor.positiveTerminalNode = secondNode.1
                    capacitor.negativeTerminalNode = firstNode.1
                    capacitor.currentGoing = firstNode.0
                } else {
                    capacitor.positiveTerminalNode = nil
                    capacitor.negativeTerminalNode = nil
                    capacitor.currentGoing = nil
                }
                models[i] = capacitor
            } else if models[i] is InductorModel {
                var inductor = models[i] as! InductorModel
                if voltageDifference > 0 {
                    inductor.positiveTerminalNode = firstNode.1
                    inductor.negativeTerminalNode = secondNode.1
                    inductor.currentGoing = secondNode.0
                } else if voltageDifference < 0 {
                    inductor.positiveTerminalNode = secondNode.1
                    inductor.negativeTerminalNode = firstNode.1
                    inductor.currentGoing = firstNode.0
                }
                models[i] = inductor
            } else if !(models[i] is VoltageSourceModel || models[i] is CurrentSourceModel) {
                if voltageDifference > 0 {
                    models[i].currentGoing = secondNode.0
                } else if voltageDifference < 0 {
                    models[i].currentGoing = firstNode.0
                } else {
                    models[i].currentGoing = nil
                }
            }
        }
    }
    
    public mutating func updateModelCurrent() {
        let voltageSources = models
            .filter{$0 is VoltageSourceModel}
            .map{$0 as! VoltageSourceModel}
        
        for source in voltageSources {
            let current = xVector[nodeCount - 1 + source.number]
            let sourceIndex = models.firstIndex {$0.description == source.description}
            models[sourceIndex!].current = abs(current)
            if let sourceComp = source.component as? Battery {
                if current > 0 {
                    models[sourceIndex!].currentGoing = sourceComp.terminals.negative
                } else if current < 0 {
                    models[sourceIndex!].currentGoing = sourceComp.terminals.positive
                }
            }
        }
        
        let inductors = models
            .filter{$0 is InductorModel}
            .map{$0 as! InductorModel}
        
        for inductor in inductors {
            let current = xVector[nodeCount + voltageSources.count + inductor.number - 1]
            let sourceIndex = models.firstIndex {$0.description == inductor.description}
            models[sourceIndex!].current = abs(current)
        }
        
        let remainingModels = models.filter{$0 is ResistorModel || $0 is CapacitorModel}
        
        for model in remainingModels {
            let matchedModels = remainingModels
                .filter{$0.connectedNodes.map{$0.value}.sorted() == model.connectedNodes.map{$0.value}.sorted()}
            
            var equivalentResistance: Double = 0
            var totalResistance: Double = 0
            for model in matchedModels {
                if let resistor = model as? ResistorModel {
                    equivalentResistance += 1 / resistor.resistance
                    totalResistance += resistor.resistance
                }
                if let capacitor = model as? CapacitorModel {
                    equivalentResistance += 1 / capacitor.equivalentResistance
                    totalResistance += capacitor.equivalentResistance
                }
            }
            
            var modelResistance: Double = 0
            
            if let resistor = model as? ResistorModel {
                modelResistance = resistor.resistance
            }
            if let capacitor = model as? CapacitorModel {
                modelResistance = capacitor.equivalentResistance
            }
            let modelIndex = models.firstIndex{$0.description == model.description}
            models[modelIndex!].current = abs(model.voltage * equivalentResistance * ( modelResistance / totalResistance))
        }
    }
}




