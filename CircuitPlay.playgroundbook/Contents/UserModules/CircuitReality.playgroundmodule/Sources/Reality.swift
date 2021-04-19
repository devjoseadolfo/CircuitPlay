import CircuitNetwork
import CircuitKit
import RealityKit
import Foundation

public class CircuitReality {
    private let network: CircuitNetwork
    private let rows: Int
    private let columns: Int
    private var origin: SIMD3<Float> = .zero
    
    public init(network: CircuitNetwork) {
        self.network = network
        self.rows = network.circuit.rows
        self.columns = network.circuit.columns
    }
    
    private func getOrigin(worldPosition: SIMD3<Float>, rows: Int, columns: Int) {
        let xPosition: Float = Float((columns - 1)) * -0.05
        let zPosition: Float = Float((rows - 1)) * -0.05
        origin = SIMD3(x: worldPosition.x + xPosition, y: worldPosition.y, z: worldPosition.z + zPosition)
    }
    
    private func getPosition(for location: Location) -> SIMD3<Float> {
        let xPosition: Float = (Float(location.x) * 0.1) + origin.x
        let zPosition: Float = (Float(location.y) * 0.1) + origin.z
        return SIMD3(x: xPosition, y: origin.y + 0.025, z: zPosition)
    }
    
    public func makeAnchorEntityForNetwork(position: SIMD3<Float>) -> AnchorEntity {
        let mainAnchor = AnchorEntity(plane: .horizontal)
        getOrigin(worldPosition: position, rows: rows, columns: columns)
        let slots: [Slot] = network.circuit.circuitGrid.rows.flatMap{$0.slots}
        for slot in slots {
            guard let entity = getModelEntity(for: slot) else { continue }
            entity.position = getPosition(for: slot.gridIndex)
            mainAnchor.addChild(entity)
        }
        for anchor in makeSignsEntity() {
            mainAnchor.addChild(anchor)
        }
        return mainAnchor
    }
    
    private func getModelEntity(for slot: Slot) -> AnchorEntity? {
        var anchorEntity: AnchorEntity? {
            switch slot.component {
            case is Battery, is Resistor, is CurrentSource, is Capacitor, is Inductor:
                return makeComponentEntity(for: slot)
            case is Ground:
                return makeGroundEntity(for: slot)
            case is Wire:
                return makeWireEntity(for: slot)
            default:
                return nil
            }
        }
        return anchorEntity
    }
    
    private func makeSignsEntity() -> [AnchorEntity] {
        var entities = [AnchorEntity]()
        for model in network.models {
            let location = getPosition(for: model.location)
            let currentGoing = model.currentGoing
            
            var plusAnchor = AnchorEntity()
            let plusEntity = try! Entity.load(named: "PlusSign")
            
            var minusAnchor = AnchorEntity()
            let minusEntity = try! Entity.load(named: "MinusSign")
            
            var currentAnchor1 = AnchorEntity()
            let currentEntity1 = try! Entity.load(named: "ArrowSign")
            
            var currentAnchor2 = AnchorEntity()
            let currentEntity2 = try! Entity.load(named: "ArrowSign")
            
            if let terminalDependent = model.component as? TerminalDependent {
                switch terminalDependent.terminals.positive {
                case .up:
                    plusAnchor.position = SIMD3(x: location.x - 0.015, y: location.y, z: location.z - 0.035)
                    minusAnchor.position = SIMD3(x: location.x - 0.015, y: location.y, z: location.z + 0.035)
                case .down:
                    plusAnchor.position = SIMD3(x: location.x - 0.015, y: location.y, z: location.z + 0.035)
                    minusAnchor.position = SIMD3(x: location.x - 0.015, y: location.y, z: location.z - 0.035)
                case .left:
                    plusAnchor.position = SIMD3(x: location.x - 0.035, y: location.y, z: location.z - 0.015)
                    minusAnchor.position = SIMD3(x: location.x + 0.035, y: location.y, z: location.z - 0.015)
                default:
                    plusAnchor.position = SIMD3(x: location.x + 0.035, y: location.y, z: location.z - 0.015)
                    minusAnchor.position = SIMD3(x: location.x - 0.035, y: location.y, z: location.z - 0.015)
                }
                switch currentGoing {
                case .up:
                    currentAnchor1.orientation = simd_quatf(angle: -Float(270).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
                    currentAnchor2.orientation = simd_quatf(angle: -Float(270).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
                    currentAnchor1.position = SIMD3(x: location.x + 0.015, y: location.y, z: location.z - 0.035)
                    currentAnchor2.position = SIMD3(x: location.x + 0.015, y: location.y, z: location.z + 0.035)
                case .down:
                    currentAnchor1.orientation = simd_quatf(angle: -Float(90).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
                    currentAnchor2.orientation = simd_quatf(angle: -Float(90).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
                    currentAnchor1.position = SIMD3(x: location.x + 0.015, y: location.y, z: location.z - 0.035)
                    currentAnchor2.position = SIMD3(x: location.x + 0.015, y: location.y, z: location.z + 0.035)
                case .left:
                    currentAnchor1.orientation = simd_quatf(angle: -Float(180).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
                    currentAnchor2.orientation = simd_quatf(angle: -Float(180).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
                    currentAnchor1.position = SIMD3(x: location.x - 0.035, y: location.y, z: location.z + 0.015)
                    currentAnchor2.position = SIMD3(x: location.x + 0.035, y: location.y, z: location.z + 0.015)
                default:
                    currentAnchor1.position = SIMD3(x: location.x - 0.035, y: location.y, z: location.z + 0.015)
                    currentAnchor2.position = SIMD3(x: location.x + 0.035, y: location.y, z: location.z + 0.015)
                }
            } else {
                switch currentGoing {
                case .up:
                    plusAnchor.position = SIMD3(x: location.x - 0.015, y: location.y, z: location.z + 0.035)
                    minusAnchor.position = SIMD3(x: location.x - 0.015, y: location.y, z: location.z - 0.035)
                    currentAnchor1.orientation = simd_quatf(angle: -Float(270).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
                    currentAnchor2.orientation = simd_quatf(angle: -Float(270).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
                    currentAnchor1.position = SIMD3(x: location.x + 0.015, y: location.y, z: location.z - 0.035)
                    currentAnchor2.position = SIMD3(x: location.x + 0.015, y: location.y, z: location.z + 0.035)
                case .down:
                    plusAnchor.position = SIMD3(x: location.x - 0.015, y: location.y, z: location.z - 0.035)
                    minusAnchor.position = SIMD3(x: location.x - 0.015, y: location.y, z: location.z + 0.035)
                    currentAnchor1.orientation = simd_quatf(angle: -Float(90).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
                    currentAnchor2.orientation = simd_quatf(angle: -Float(90).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
                    currentAnchor1.position = SIMD3(x: location.x + 0.015, y: location.y, z: location.z - 0.035)
                    currentAnchor2.position = SIMD3(x: location.x + 0.015, y: location.y, z: location.z + 0.035)
                case .left:
                    plusAnchor.position = SIMD3(x: location.x + 0.035, y: location.y, z: location.z - 0.015)
                    minusAnchor.position = SIMD3(x: location.x - 0.035, y: location.y, z: location.z - 0.015)
                    currentAnchor1.orientation = simd_quatf(angle: -Float(180).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
                    currentAnchor2.orientation = simd_quatf(angle: -Float(180).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
                    currentAnchor1.position = SIMD3(x: location.x - 0.035, y: location.y, z: location.z + 0.015)
                    currentAnchor2.position = SIMD3(x: location.x + 0.035, y: location.y, z: location.z + 0.015)
                default:
                    plusAnchor.position = SIMD3(x: location.x - 0.035, y: location.y, z: location.z - 0.015)
                    minusAnchor.position = SIMD3(x: location.x + 0.035, y: location.y, z: location.z - 0.015)
                    currentAnchor1.position = SIMD3(x: location.x - 0.035, y: location.y, z: location.z + 0.015)
                    currentAnchor2.position = SIMD3(x: location.x + 0.035, y: location.y, z: location.z + 0.015)
                }
            }
            plusAnchor.addChild(plusEntity)
            minusAnchor.addChild(minusEntity)
            currentAnchor1.addChild(currentEntity1)
            currentAnchor2.addChild(currentEntity2)
            entities.append(contentsOf: [plusAnchor, minusAnchor, currentAnchor1, currentAnchor2])
        }
        return entities
    }
    
    private func makeWireEntity(for slot: Slot) -> AnchorEntity {
        let anchor = AnchorEntity()
        if let connectable = slot.component as? Connectable {
            var entityName: String {
                switch connectable.connectionType {
                case .cross:
                    return "WireCross"
                case .corner:
                    return "WireCorner"
                case .tshape:
                    return "WireTshape"
                default:
                    return "WireStraight"
                }
            }
            let entity = try! Entity.load(named: entityName)
            entity.children.forEach { $0.name = String(slot.gridIndex.x) + "," + String(slot.gridIndex.y) }
            entity.name = String(slot.gridIndex.x) + "," + String(slot.gridIndex.y)
            anchor.name = String(slot.gridIndex.x) + "," + String(slot.gridIndex.y)
            entity.generateCollisionShapes(recursive: true)
            anchor.addChild(entity)
            switch connectable.connectionType {
            case .straight:
                if connectable.contacts.contactPoints == Set([.up, .down]) {
                    anchor.orientation = simd_quatf(angle: Float(90).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
                }
            case .corner:
                if connectable.contacts.contactPoints == Set([.down, .left]) {
                    anchor.orientation = simd_quatf(angle: -Float(90).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
                } else if connectable.contacts.contactPoints == Set([.left, .up]) {
                    anchor.orientation = simd_quatf(angle: -Float(180).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
                } else if connectable.contacts.contactPoints == Set([.up, .right]) {
                    anchor.orientation = simd_quatf(angle: -Float(270).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
                }
            case .tshape:
                if connectable.contacts.contactPoints == Set([.down, .left, .up]) {
                    anchor.orientation = simd_quatf(angle: -Float(90).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
                } else if connectable.contacts.contactPoints == Set([.left, .up, .right]) {
                    anchor.orientation = simd_quatf(angle: -Float(180).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
                } else if connectable.contacts.contactPoints == Set([.up, .right, .down]) {
                    anchor.orientation = simd_quatf(angle: -Float(270).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
                }
            default:
                break
            }
        }
        return anchor
    }
    
    private func makeGroundEntity(for slot: Slot) -> AnchorEntity {
        let entity = try! Entity.load(named: "Ground")
        entity.name = String(slot.gridIndex.x) + "," + String(slot.gridIndex.y)
        entity.generateCollisionShapes(recursive: true)
        entity.children.forEach { $0.name = String(slot.gridIndex.x) + "," + String(slot.gridIndex.y) }
        let anchor = AnchorEntity()
        anchor.name = String(slot.gridIndex.x) + "," + String(slot.gridIndex.y)
        anchor.addChild(entity)
        if let connectable = slot.component as? Connectable {
            switch connectable.contacts.contactPoints {
            case [.down]:
                anchor.orientation = simd_quatf(angle: -Float(90).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
            case [.left]:
                anchor.orientation = simd_quatf(angle: -Float(180).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
            case [.up]:
                anchor.orientation = simd_quatf(angle: -Float(270).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
            default:
                break
            }
        }
        return anchor
    }
    
    private func makeComponentEntity(for slot: Slot) -> AnchorEntity {
        var entityName: String {
            switch slot.component {
            case is Battery:
                return "Battery"
            case is Resistor:
                return "Resistor"
            case is CurrentSource:
                return "Source"
            case is Capacitor:
                return "Capacitor"
            case is Inductor:
                return "Inductor"
            default:
                return ""
            }
        }
        let entity = try! Entity.load(named: entityName)
        entity.name = String(slot.gridIndex.x) + "," + String(slot.gridIndex.y)
        entity.generateCollisionShapes(recursive: true)
        entity.children.forEach { $0.name = String(slot.gridIndex.x) + "," + String(slot.gridIndex.y) }
        let anchor = AnchorEntity()
        anchor.name = String(slot.gridIndex.x) + "," + String(slot.gridIndex.y)
        anchor.addChild(entity)
        
        if let voltageSource = slot.component as? Battery {
            switch voltageSource.terminals.positive {
            case .up:
                anchor.orientation = simd_quatf(angle: -Float(90).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
            case .right:
                anchor.orientation = simd_quatf(angle: -Float(180).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
            case .down:
                anchor.orientation = simd_quatf(angle: -Float(270).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
            default:
                anchor.orientation = simd_quatf(angle: Float(0).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
            }
        } else if let connectable = slot.component as? Connectable, connectable.contacts.contactPoints == Set([.up, .down]) {
            anchor.orientation = simd_quatf(angle: Float(90).toRadians(), axis: SIMD3(x: 0, y: 1, z: 0))
        }
        return anchor
    }
}

extension Float {
    public func toRadians() -> Float {
        return self * Float.pi / 180.0
    }
}

