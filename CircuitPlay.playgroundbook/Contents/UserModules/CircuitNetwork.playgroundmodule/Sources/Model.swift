import CircuitKit

public protocol Model: CustomStringConvertible {
    var number: Int { get }
    var component:  Connectable { get }
    var location: Location { get }
    
    var connectedNodes: [Direction : Int] { get set}
    
    var voltage: Double { get set }
    var current: Double { get set }
    
    var currentGoing: Direction? { get set }
    
    var power: Double { get }
}

public protocol TerminalDependentModel: Model {
    var positiveTerminalNode: Int? { get set }
    var negativeTerminalNode: Int? { get set }
}
