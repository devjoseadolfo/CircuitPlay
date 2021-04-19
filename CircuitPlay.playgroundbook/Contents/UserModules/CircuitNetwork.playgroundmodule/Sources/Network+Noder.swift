import CircuitKit

extension CircuitNetwork {
    
    public mutating func attachHiddenGroundNodes() {
        for model in models {
            for direction in model.component.contacts.contactPoints {
                do {
                    let nextLocation = try circuit.move(from: model.location, to: direction)
                    guard circuit.circuitGrid[nextLocation].component is Ground else {
                        continue
                    }
                    let modelIndex = models.firstIndex{$0.description == model.description}!
                    let otherNode = model.connectedNodes.first!.value
                    nodes[otherNode].connectedNodes[model.description] = 0
                    nodes[0].connectedNodes[model.description] = otherNode
                    models[modelIndex].connectedNodes[direction] = 0
                    
                    if let terminalDependent = model as? TerminalDependentModel {
                        var terminalModel = models[modelIndex] as! TerminalDependentModel
                        if terminalDependent.positiveTerminalNode == nil && terminalDependent.negativeTerminalNode != nil {
                            terminalModel.positiveTerminalNode = 0
                        } else if terminalDependent.positiveTerminalNode != nil && terminalDependent.negativeTerminalNode == nil{
                            terminalModel.positiveTerminalNode = 0
                        }
                        models[modelIndex] = terminalModel
                    }
                } catch {
                    continue
                }
            }
        }
    }
    
    public mutating func assignInductorNodes() {
        let inductors = models
            .filter { $0 is InductorModel}
            .map { $0 as! InductorModel}
        
        for ind in inductors {
            var inductor = ind
            var nodes = inductor.connectedNodes.map{$0.value}
            inductor.positiveTerminalNode = nodes[0]
            inductor.negativeTerminalNode = nodes[1]
            let index = models.firstIndex { $0.description == inductor.description}!
            models[index] = inductor
        }
    }
    
    public mutating func makeHiddenNodes() {
        func modelSearch(model: Model) -> [(Model, Model, Direction)]{
            var pairs: [(Model, Model, Direction)] = []
            for direction in model.component.contacts.contactPoints {
                do {
                    let nextLocation = try circuit.move(from: model.location, to: direction)
                    guard let adjacentModel = models.first{$0.location == nextLocation} as? Model else { continue }
                    pairs.append((model, adjacentModel, direction))
                } catch {
                    continue
                }
            }
            return pairs
        }
        var collectedPairs: [(Model, Model, Direction)] = []
        for model in models {
            collectedPairs.append(contentsOf: modelSearch(model: model))
        }
        // print(collectedPairs)
        for pair in collectedPairs {
            let nodeCount = nodes.count
            var newNode = Node(nodeCount)
            let firstModelIndex = models.firstIndex { $0.description == pair.0.description }
            let secondModelIndex = models.firstIndex { $0.description == pair.1.description }
            newNode.connectedModels.append(pair.0.description)
            newNode.connectedModels.append(pair.1.description)
            if let modelOppNode = pair.0.connectedNodes[pair.2.opposite] {
                let modelName: String = pair.0.description
                newNode.connectedModels.append(modelName)
                newNode.connectedNodes[modelName] = modelOppNode
            }
            if let adjacentOppNode = pair.1.connectedNodes[pair.2] {
                let modelName: String = pair.1.description
                newNode.connectedModels.append(modelName)
                newNode.connectedNodes[modelName] = adjacentOppNode
            }
            if !nodes.contains{ $0.connectedNodes == newNode.connectedNodes} {
                models[firstModelIndex!].connectedNodes[pair.2] = newNode.number
                models[secondModelIndex!].connectedNodes[pair.2.opposite] = newNode.number
                
                if let modelOppNode = pair.0.connectedNodes[pair.2.opposite] {
                    nodes[modelOppNode].connectedNodes[pair.0.description] = newNode.number
                }
                if let adjacentOppNode = pair.1.connectedNodes[pair.2] {
                    nodes[adjacentOppNode].connectedNodes[pair.1.description] = newNode.number
                }
                
                if let terminalDependentComp = pair.0.component as? TerminalDependent,
                   var terminalDependentModel = models[firstModelIndex!] as? TerminalDependentModel {
                    if pair.2 == terminalDependentComp.terminals.positive {
                        terminalDependentModel.positiveTerminalNode = newNode.number
                    } else if pair.2 == terminalDependentComp.terminals.negative {
                        terminalDependentModel.negativeTerminalNode = newNode.number
                    }
                    models[firstModelIndex!] = terminalDependentModel
                }
                
                if let terminalDependentComp = pair.1.component as? TerminalDependent,
                   var terminalDependentModel = models[secondModelIndex!] as? TerminalDependentModel {
                    if pair.2.opposite == terminalDependentComp.terminals.positive {
                        terminalDependentModel.positiveTerminalNode = newNode.number
                    } else if pair.2.opposite == terminalDependentComp.terminals.negative {
                        terminalDependentModel.negativeTerminalNode = newNode.number
                    }
                    models[secondModelIndex!] = terminalDependentModel
                }
                
                nodes.append(newNode)
            }
        }
    }
    
    public mutating func assignConnections() {
        for model in models {
            for direction in model.component.contacts.contactPoints {
                do {
                    let nextLocation = try circuit.move(from: model.location, to: direction)
                    let matchedNode = nodes.filter { node in
                        node.openings.contains { opening in
                            opening.0 == nextLocation && opening.1 == direction.opposite
                        }
                    }
                    let modelIndex = models.firstIndex{ $0.description == model.description }
                    for node in matchedNode {
                        models[modelIndex!].connectedNodes[direction] = node.number
                        nodes[node.number].connectedModels.append(model.description)
                        if let terminalDependentComp = model.component as? TerminalDependent,
                           var terminalDependentModel = models[modelIndex!] as? TerminalDependentModel {
                            if direction == terminalDependentComp.terminals.positive {
                                terminalDependentModel.positiveTerminalNode = node.number
                            } else if direction == terminalDependentComp.terminals.negative {
                                terminalDependentModel.negativeTerminalNode = node.number
                            }
                            models[modelIndex!] = terminalDependentModel
                        }
                    }
                } catch {
                    continue
                }
            }
        }
        for node in nodes {
            for model in node.connectedModels {
                let matchedNodes = nodes
                    .filter { $0.number != node.number }
                    .filter { possNode in
                        possNode.connectedModels.contains { possModel in
                            possModel == model
                        }
                    }
                for matched in matchedNodes {
                    nodes[matched.number].connectedNodes[model] = node.number
                    nodes[node.number].connectedNodes[model] = matched.number
                }
            }
        }
    }
    
    public mutating func makeNodesAndModels() {
        let availableWireCount = circuit.circuitGrid.rows
            .flatMap { $0.slots }
            .filter {$0.component is Wire && $0.assocNode == nil}
            .count
        
        // print(availableWireCount)
        
        if availableWireCount > 0 {
            makeNode()
            return makeNodesAndModels()
        }
        let availableModelCount = circuit.circuitGrid.rows
            .flatMap { $0.slots }
            .filter {($0.component is Resistor || $0.component is Battery || $0.component is CurrentSource || $0.component is Inductor || $0.component is Capacitor) && $0.assocModel == nil}
            .count
        
        // print(availableModelCount)
        
        if availableModelCount > 0 {
            makeModel()
            return makeNodesAndModels()
        }
        return
    }
    
    public mutating func makeNode() {
        let nodeLocations = circuit.circuitGrid.rows
            .flatMap { $0.slots }
            .filter { $0.component is Wire && $0.assocNode == nil}
            .map { $0.gridIndex }
        guard nodeLocations.count > 0 else { return }
        let firstLocation = nodeLocations.first!
        // print(nodeLocations)
        
        // print("Making node for", firstLocation)
        
        let nodeCount = nodes.count
        let locations = wireRecursion(firstLocation: firstLocation)
        let openings = getOpenings(for: locations)
        var newNode = Node(nodeCount)
        newNode.locations = locations
        
        // print("Included locations are", locations)
        
        newNode.openings = openings
        nodes.append(newNode)
        locations.forEach {
            circuit.circuitGrid[$0].assocNode = nodeCount
        }
    }
    
    public mutating func makeModel() {
        let modelLocations = circuit.circuitGrid.rows
            .flatMap { $0.slots }
            .filter {!($0.component is BlankSpace || $0.component is Wire || $0.component is Ground) && $0.assocModel == nil}
            .map { $0.gridIndex }
        guard modelLocations.count > 0 else { return }
        let firstLocation = modelLocations.first!
        
        //print("Making model for", firstLocation)
        
        let component = circuit.circuitGrid[firstLocation].component
        var model: Model? {
            switch component {
            case is Battery:
                let count = models.filter{$0 is VoltageSourceModel}.count
                return VoltageSourceModel(for: component as! Connectable, count: count, location: firstLocation)
            case is CurrentSource:
                let count = models.filter{$0 is CurrentSourceModel}.count
                return CurrentSourceModel(for: component as! CurrentSource, count: count, location: firstLocation)
            case is Resistor:
                let count = models.filter{$0 is ResistorModel}.count
                return ResistorModel(for: component as! Resistor, count: count, location: firstLocation)
            case is Capacitor:
                let count = models.filter{$0 is CapacitorModel}.count
                return CapacitorModel(for: component as! Capacitor, count: count, timeStep: timeStep, location: firstLocation)
            case is Inductor:
                let count = models.filter{$0 is InductorModel}.count
                return InductorModel(for: component as! Inductor, count: count, timeStep: timeStep, location: firstLocation)
            default:
                return nil
            }
        }
        guard let newModel = model else { return }
        models.append(newModel)
        circuit.circuitGrid[firstLocation].assocModel = newModel.description
    }
    
    public mutating func makeGroundNode() {
        let groundSlots = circuit.circuitGrid.rows
            .flatMap { $0.slots }
            .filter { $0.component is Ground }
            .map { $0.gridIndex }
        var locations = [Location]()
        var openings = [(Location, Direction)]()
        for location in groundSlots {
            let ground = circuit.circuitGrid[location].component as! Ground
            let direction = ground.contacts.contactPoints.first!
            do {
                let nextLocation = try circuit.move(from: location, to: direction)
                guard let nextWire = circuit.circuitGrid[nextLocation].component as? Wire,
                      nextWire.contactPoints.contains(direction.opposite) else {
                    locations.append(location)
                    openings.append((location, ground.contactPoints[0]))
                    groundCount += 1
                    circuit.circuitGrid[location].assocNode = 0
                    continue
                }
                let newLocations = wireRecursion(firstLocation: nextLocation)
                let newOpenings = getOpenings(for: newLocations)
                locations.append(contentsOf: newLocations)
                openings.append(contentsOf: newOpenings)
                groundCount += 1
                circuit.circuitGrid[location].assocNode = 0
                locations.forEach {
                    circuit.circuitGrid[$0].assocNode = 0
                }
            } catch {
                locations.append(location)
                openings.append((location, ground.contactPoints[0]))
                groundCount += 1
                circuit.circuitGrid[location].assocNode = 0
            }
        }
        nodes[0].openings = openings
        nodes[0].locations = locations
    }
    
    public func getOpenings(for locations: [Location]) -> [(Location, Direction)] {
        let slots = locations.map{circuit.circuitGrid[$0]}
        var openings = [(Location, Direction)]()
        slots.forEach { slot in
            let wire = slot.component as! Wire
            for direction in wire.contactPoints {
                do {
                    let newLocation = try circuit.move(from: slot.gridIndex, to: direction)
                    if locations.contains(where: {$0 == newLocation}) {
                        continue
                    }
                    if !(circuit.circuitGrid[newLocation] is Wire), !(circuit.circuitGrid[newLocation] is BlankSpace) {
                        openings.append((slot.gridIndex, direction))
                        continue
                    }
                } catch {
                    continue
                }
            }
        }
        return openings
    }
    
    public func wireRecursion(firstLocation: Location,
                              included: [Location] = [],
                              nextLocation: Location? = nil) -> [Location] {
        guard let nextLocation = nextLocation else {
            guard let connectable = circuit.circuitGrid[firstLocation].component as? Wire else {
                // print("First location not wire.")
                return []
            }
            for contact in connectable.contacts.contactPoints {
                do {
                    let newLocation =  try circuit.move(from: firstLocation, to: contact)
                    // print("Going", contact, "from", firstLocation, "to", newLocation)
                    guard circuit.circuitGrid[newLocation].component is Wire,
                          !included.contains(where: { $0 == newLocation}) else {
                        // print(newLocation, "is already included")
                        continue
                    }
                    if !included.contains(where: {$0 == firstLocation}) {
                        return wireRecursion(firstLocation: firstLocation, included: included + [firstLocation, newLocation], nextLocation: newLocation)
                    } else {
                        return wireRecursion(firstLocation: firstLocation, included: included + [newLocation], nextLocation: newLocation)
                    }
                } catch {
                    continue
                }
            }
            if included.isEmpty {
                return [firstLocation]
            }
            return included
        }
        guard let connectable = circuit.circuitGrid[nextLocation].component as? Connectable else {
            // print("Not wire in", nextLocation)
            return []
        }
        for contact in connectable.contacts.contactPoints {
            do {
                let newLocation =  try circuit.move(from: nextLocation, to: contact)
                // print("Going", contact, "from", nextLocation, "to", newLocation)
                guard !included.contains(where: { $0 == newLocation}),
                      circuit.circuitGrid[newLocation].component is Wire else {
                    continue
                }
                return wireRecursion(firstLocation: firstLocation, included: included + [newLocation], nextLocation: newLocation)
            } catch {
                continue
            }
        }
        return wireRecursion(firstLocation: firstLocation, included: included)
    }
}

