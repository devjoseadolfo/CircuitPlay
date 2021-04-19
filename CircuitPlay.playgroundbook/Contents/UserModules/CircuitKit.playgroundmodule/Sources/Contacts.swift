public enum ConnectionType {
    case single, straight, corner, tshape, cross, none
}

public struct Contacts: CustomStringConvertible, Equatable {
    public var contactPoints: Set<Direction>
    
    public var orientation: Orientation {
        if contactPoints == Set([.up, .down]) {
            return .vertical
        } else {
            return .horizontal
        }
    }
    
    var connectionType: ConnectionType {
        switch contactPoints.count {
        case 1:
            return .single
        case 2:
            switch contactPoints {
            case Set([.right, .left]), Set([.up, .down]):
                return .straight
            default:
                return .corner
            }
        case 3:
            return .tshape
        case 4:
            return .cross
        default:
            return .none
        }
    }
    public var description: String {
        switch contactPoints {
        case Set([.up]):
            return "╵"
        case Set([.down]):
            return "╷"
        case Set([.right]):
            return "╴"
        case Set([.left]):
            return "╶"
        case Set([.up, .down]):
            return "│"
        case Set([.right, .left]):
            return  "─"
        case Set([.up, .left]):
            return "┘"
        case Set([.up, .right]):
            return "└"
        case Set([.left, .down]):
            return "┐"
        case Set([.right, .down]):
            return "┌"
        case Set([.up, .left, .right]):
            return "┴"
        case Set([.down, .right, .left]):
            return "┬"
        case Set([.up, .down, .left]):
            return "┤"
        case Set([.up, .down, .right]):
            return "├"
        case Set([.up, .down, .left, .right]):
            return "┼"
        default:
            return " "
        }
    }
    
    public init(_ contactPoints: [Direction]) {
        self.contactPoints = Set(contactPoints)
    }
    
    public mutating func rotate(_ rotation: Rotation) {
        switch rotation {
        case .clockwise:
            self.contactPoints = Set(contactPoints.map({$0.rotationClockwise}))
        case .counterclockwise:
            self.contactPoints = Set(contactPoints.map({$0.rotationCounterclockwise}))
        }
    }
    
    public mutating func flip(_ orientation: Orientation) {
        switch orientation {
        case .horizontal:
            self.contactPoints = Set(contactPoints.map({$0.flipHorizontal}))
        case .vertical:
            self.contactPoints = Set(contactPoints.map({$0.flipVertical}))
        }
    }
    
    public static func == (lhs: Contacts, rhs: Contacts) -> Bool {
        return
            lhs.contactPoints == rhs.contactPoints
    }
    
    public func getRotationCount(count: inout Double) {
        switch connectionType {
        case .single:
            switch contactPoints {
            case Set([.up]):
                count = 3
            case Set([.right]):
                count = 0
            case Set([.left]):
                count = 1
            default:
                count = 2
            }
        case .straight:
            switch contactPoints {
            case Set([.up, .down]):
                count = 1
            default:
                count = 0
            }
        case .corner:
            switch contactPoints {
            case Set([.up, .right]):
                count = 1
            case Set([.down, .right]):
                count = 2
            case Set([.down, .left]):
                count = 3
            default:
                count = 0
            }
        case .tshape:
            switch contactPoints {
            case Set([.up, .left, .right]):
                count = 1
            case Set([.down, .up, .right]):
                count = 2
            case Set([.down, .left, .right]):
                count = 3
            default:
                count = 0
            }
        default:
            count = 0
        }
    }
}

