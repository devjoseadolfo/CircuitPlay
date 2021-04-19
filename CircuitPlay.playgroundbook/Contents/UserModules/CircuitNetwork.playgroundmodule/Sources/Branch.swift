import CircuitKit

public enum End {
    case first, last
}

public struct Branch: CustomStringConvertible {
    public var number: Int
    public var description: String { "B" + String(number) }
    public var path: [Location]
    public var connectedBranches: [Int: End] = [:]
    
    public var dependence: String?
    public var dependenceFirst: Location?
    public var dependenceLast: Location?
    
    public var isReversed: Bool = false
    public var current: Double = 0
    public init(_ count: Int, path: [Location]) {
        self.number = count
        self.path = path
    }
}

