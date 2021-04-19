import CircuitKit

public struct InductorModel: TerminalDependentModel {
    public var number: Int
    public var description: String { "L" + String(number + 1)}
    public var component: Connectable
    public var location: Location
    
    public var positiveTerminalNode: Int?
    public var negativeTerminalNode: Int?
    
    public var timeStep: Double
    
    public var connectedNodes: [Direction : Int] = [:]
    
    public var inductance: Double
    public var equivalentResistance: Double { inductance / Double(timeStep)}
    public var equivalentVoltage: Double { -current * inductance / timeStep }
    
    public var voltage: Double = 0
    public var current: Double = 0.0000001
    public var power: Double { voltage * current }
    
    public var currentGoing: Direction?
    
    public init(for inductor: Inductor, count: Int, timeStep: Double, location: Location) {
        component = inductor
        number = count
        inductance = inductor.measurements[0].value
        self.location = location
        self.timeStep = timeStep
    }
}

