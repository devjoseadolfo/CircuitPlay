import CircuitKit

public struct CapacitorModel: TerminalDependentModel {
    public var number: Int
    public var description: String { "C" + String(number + 1)}
    public var component: Connectable
    public var location: Location
    
    public var positiveTerminalNode: Int?
    public var negativeTerminalNode: Int?
    
    public var timeStep: Double
    
    public var connectedNodes: [Direction : Int] = [:]
    
    public var capacitance: Double
    public var equivalentResistance: Double { Double(timeStep) / capacitance }
    public var equivalentCurrent: Double { voltage * capacitance / timeStep}
    
    public var voltage: Double = 0.0000001
    public var current: Double = 0
    public var power: Double { voltage * current }
    
    public var currentGoing: Direction?
    
    public init(for capacitor: Capacitor, count: Int, timeStep: Double, location: Location) {
        component = capacitor
        number = count
        capacitance = capacitor.measurements[0].value
        self.location = location
        self.timeStep = timeStep
    }
}
