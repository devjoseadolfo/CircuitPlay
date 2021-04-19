import CircuitKit

public struct VoltageSourceModel: TerminalDependentModel {
    public var number: Int
    public var description: String { "Vs" + String(number + 1)}
    public var component: Connectable
    public var location: Location
    
    public var positiveTerminalNode: Int?
    public var negativeTerminalNode: Int?
    
    public var connectedNodes: [Direction : Int] = [:]
    
    public var voltage: Double
    public var current: Double = 0
    public var power: Double { voltage * current }
    
    public var currentGoing: Direction?
    
    public var signal: SignalType = .direct
    public var amplitude: Double = 0
    public var frequency: Double = 0
    
    public init(for voltageSource: Connectable, count: Int, location: Location) {
        component = voltageSource
        number = count
        voltage = voltageSource.measurements[0].value
        self.location = location
        
        let terminalDependent = voltageSource as! TerminalDependent
        
        if voltage == 0 {
            currentGoing = nil
        } else if voltage > 0 {
            currentGoing = terminalDependent.terminals.positive
        } else {
            currentGoing = terminalDependent.terminals.negative
        }
        
        if let source = voltageSource as? VoltageSource {
            amplitude = source.measurements[0].value
            frequency = source.measurements[1].value
            signal = source.signal
        }
    }
}


