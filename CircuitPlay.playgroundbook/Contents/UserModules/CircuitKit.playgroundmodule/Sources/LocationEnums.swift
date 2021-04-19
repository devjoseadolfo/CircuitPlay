public enum Direction: String, Identifiable, Hashable {
    case right, left, up, down
    
    public var id: String {
        self.rawValue.capitalized
    }
    
    public var int: Int {
        switch self {
        case .right:
            return 0
        case .left:
            return 2
        case .up:
            return 3
        case .down:
            return 1
        }
    }
    
    public var symbol: String {
        switch self {
        case .right:
            return "arrow.right"
        case .left:
            return "arrow.left"
        case .up:
            return "arrow.up"
        case .down:
            return "arrow.down"
        }
    }
    
    public var chevron: String {
        switch self {
        case .right:
            return "chevron.right"
        case .left:
            return "chevron.left"
        case .up:
            return "chevron.up"
        case .down:
            return "chevron.down"
        }
    }
    
    public var rotationClockwise: Direction {
        switch self {
        case .right:
            return .down
        case .left:
            return .up
        case .up:
            return .right
        case .down:
            return .left
        }
    }
    
    public var rotationCounterclockwise: Direction {
        switch self {
        case .right:
            return .up
        case .left:
            return .down
        case .up:
            return .left
        case .down:
            return .right
        }
    }
    
    public var flipHorizontal: Direction {
        switch self {
        case .right:
            return .left
        case .left:
            return .right
        case .up:
            return .up
        case .down:
            return .down
        }
    }
    
    public var flipVertical: Direction {
        switch self {
        case .right:
            return .right
        case .left:
            return .left
        case .up:
            return .down
        case .down:
            return .up
        }
    }
    
    public var opposite: Direction {
        switch self {
        case .right:
            return .left
        case .left:
            return .right
        case .up:
            return .down
        case .down:
            return .up
        }
    }
}

public enum Rotation {
    case clockwise, counterclockwise
}

public enum Orientation {
    case vertical, horizontal
}

