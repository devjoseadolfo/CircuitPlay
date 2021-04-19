import CircuitKit

public struct ResistorModel: Model {
    public var number: Int
    public var description: String { "R" + String(number + 1)}
    public var component: Connectable
    public var location: Location
    
    public var connectedNodes: [Direction : Int] = [:]
    
    public var resistance: Double = 0
    public var voltage: Double = 0
    public var current: Double = 0
    public var power: Double { voltage * current }
    
    public var currentGoing: Direction?
    
    public init(for resistor: Resistor, count: Int, location: Location) {
        component = resistor
        number = count
        self.location = location
        resistance = resistor.measurements[0].value
    }
}

