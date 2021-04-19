import CircuitKit

public struct CurrentSourceModel: TerminalDependentModel {
    public var number: Int
    public var description: String { "Is" + String(number + 1)}
    public var component: Connectable
    public var location: Location
    
    public var positiveTerminalNode: Int?
    public var negativeTerminalNode: Int?
    
    public var connectedNodes: [Direction : Int] = [:]
    
    public var voltage: Double = 0
    public var current: Double
    public var power: Double { voltage * current }
    
    public var currentGoing: Direction?
    
    public init(for currentSource: CurrentSource, count: Int, location: Location) {
        component = currentSource
        number = count
        self.location = location
        current = currentSource.measurements[0].value
        if current == 0 {
            currentGoing = nil
        } else if current > 0 {
            currentGoing = currentSource.terminals.positive
        } else {
            currentGoing = currentSource.terminals.negative
        }
    }
}


