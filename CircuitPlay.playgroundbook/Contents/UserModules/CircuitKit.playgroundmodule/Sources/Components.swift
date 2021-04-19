import Foundation

public struct BlankSpace: CircuitComponent {
    public var componentType: ComponentType = .spacer
    public var connectionType: ConnectionType = .none
    public var description: String = "☐"
    
    public var measurements: [CircuitUnit] = []
    
    public init() { }
    
    public mutating func rotate(_ rotation: Rotation) {}
}

public struct Wire: Conductor {
    public var componentType: ComponentType = .wire
    public var connectionType: ConnectionType { contacts.connectionType }
    public var description: String { contacts.description }
    
    public var measurements: [CircuitUnit] = []
    
    public var contacts: Contacts
    public var contactPoints: [Direction] {
        Array(contacts.contactPoints)
    }
    
    public var rotationCount: Double = 0
    
    public init(_ contacts: Direction...) {
        self.contacts = Contacts(contacts)
        self.contacts.getRotationCount(count: &rotationCount)
    }
    
    public mutating func rotate(_ rotation: Rotation) {
        self.contacts.rotate(rotation)
        updateRotationCount(count: &rotationCount, rotation: rotation)
    }
}

public struct Ground: Conductor {
    public var componentType: ComponentType = .ground
    public var connectionType: ConnectionType = .single
    public var description: String { contacts.description }
    
    public var measurements: [CircuitUnit] = []
    
    public var contacts: Contacts
    public var contactPoints: [Direction] {
        Array(contacts.contactPoints)
    }
    
    public var rotationCount: Double = 0
    
    public init(_ contact: Direction) {
        self.contacts = Contacts([contact])
        self.contacts.getRotationCount(count: &rotationCount)
    }
    
    public mutating func rotate(_ rotation: Rotation) {
        self.contacts.rotate(rotation)
        updateRotationCount(count: &rotationCount, rotation: rotation)
    }
}

public struct Battery: Connectable, TerminalDependent {
    public var componentType: ComponentType = .battery
    public var connectionType: ConnectionType = .straight
    public var description: String = "V"
    
    public var rotationCount: Double
    
    public var contacts: Contacts { Contacts([terminals.positive, terminals.negative])}
    public var terminals: (positive: Direction, negative: Direction)
    
    public var measurements: [CircuitUnit] = [5.00.volts(), 1.00.hertz()]
    public var signal: SignalType = .direct
    
    public init(positive: Direction, negative: Direction) {
        self.terminals = (positive: positive, negative: negative)
        self.rotationCount = getRotationCount(positiveTerminal: terminals.positive)
    }
    
    public mutating func rotate(_ rotation: Rotation) {
        self.terminals.positive = rotation == .clockwise ? terminals.positive.rotationClockwise : terminals.positive.rotationCounterclockwise
        self.terminals.negative = rotation == .clockwise ? terminals.negative.rotationClockwise : terminals.negative.rotationCounterclockwise
        updateRotationCount(count: &rotationCount, rotation: rotation)
    }
}

public struct VoltageSource: Connectable, TerminalDependent {
    public var componentType: ComponentType = .voltageSource
    public var connectionType: ConnectionType = .straight
    public var description: String = "V"
    
    public var contacts: Contacts { Contacts([terminals.positive, terminals.negative])}
    public var terminals: (positive: Direction, negative: Direction)
    
    public var rotationCount: Double
    
    public var measurements: [CircuitUnit] = [5.00.volts(), 1.00.hertz()]
    public var signal: SignalType = .direct
    
    public init(positive: Direction, negative: Direction) {
        self.terminals = (positive: positive, negative: negative)
        self.rotationCount = getRotationCount(positiveTerminal: terminals.positive)
    }
    
    public mutating func rotate(_ rotation: Rotation) {
        self.terminals.positive = rotation == .clockwise ? terminals.positive.rotationClockwise : terminals.positive.rotationCounterclockwise
        self.terminals.negative = rotation == .clockwise ? terminals.negative.rotationClockwise : terminals.negative.rotationCounterclockwise
        updateRotationCount(count: &rotationCount, rotation: rotation)
    }
}

public struct CurrentSource: Connectable, TerminalDependent {
    public var componentType: ComponentType = .currentSource
    public var connectionType: ConnectionType = .straight
    public var description: String = "I"
    
    public var contacts: Contacts { Contacts([terminals.positive, terminals.negative])}
    public var terminals: (positive: Direction, negative: Direction)
    
    public var rotationCount: Double
    
    public var measurements: [CircuitUnit] = [1.00.amperes()]
    public var signal: SignalType = .direct
    
    public init(positive: Direction, negative: Direction) {
        self.terminals = (positive: positive, negative: negative)
        self.rotationCount = getRotationCount(positiveTerminal: terminals.positive)
    }
    
    public mutating func rotate(_ rotation: Rotation) {
        self.terminals.positive = rotation == .clockwise ? terminals.positive.rotationClockwise : terminals.positive.rotationCounterclockwise
        self.terminals.negative = rotation == .clockwise ? terminals.negative.rotationClockwise : terminals.negative.rotationCounterclockwise
        updateRotationCount(count: &rotationCount, rotation: rotation)
    }
}

public struct Resistor: Connectable {
    public var componentType: ComponentType = .resistor
    public var connectionType: ConnectionType = .straight
    public var description: String = "R"
    
    public var rotationCount: Double = 0
    
    public var contacts: Contacts
    
    public var measurements: [CircuitUnit] = [10.00.ohms()]
    
    public init(_ contacts: Direction...) {
        self.contacts = Contacts(contacts)
        self.rotationCount = getRotationCount(directions: contacts)
    }
    
    public mutating func rotate(_ rotation: Rotation) {
        self.contacts.rotate(rotation)
        updateRotationCount(count: &rotationCount, rotation: rotation)
    }
}

public struct Diode: Connectable, TerminalDependent {
    public var componentType: ComponentType = .diode
    public var connectionType: ConnectionType = .straight
    public var description: String = "D"
    
    public var measurements: [CircuitUnit] = []
    
    public var contacts: Contacts  { Contacts([terminals.positive, terminals.negative]) }
    public var terminals: (positive: Direction, negative: Direction)
    
    public var rotationCount: Double = 0
    
    public init(positive: Direction, negative: Direction) {
        self.terminals = (positive: positive, negative: negative)
        self.rotationCount = getRotationCount(positiveTerminal: terminals.positive)
    }
    
    public mutating func rotate(_ rotation: Rotation) {
        self.terminals.positive = rotation == .clockwise ? terminals.positive.rotationClockwise : terminals.positive.rotationCounterclockwise
        self.terminals.negative = rotation == .clockwise ? terminals.negative.rotationClockwise : terminals.negative.rotationCounterclockwise
        updateRotationCount(count: &rotationCount, rotation: rotation)
    }
}

public struct Capacitor: Connectable {
    public var componentType: ComponentType = .capacitor
    public var connectionType: ConnectionType = .straight
    public var description: String = "C"
    
    public var rotationCount: Double = 0
    
    public var contacts: Contacts
    
    public var measurements: [CircuitUnit] = [0.01.farads()]
    
    public init(_ contacts: Direction...) {
        self.contacts = Contacts(contacts)
        self.rotationCount = getRotationCount(directions: contacts)
    }
    
    public mutating func rotate(_ rotation: Rotation) {
        self.contacts.rotate(rotation)
        updateRotationCount(count: &rotationCount, rotation: rotation)
    }
}

public struct Inductor: Connectable {
    public var componentType: ComponentType = .inductor
    public var connectionType: ConnectionType = .straight
    public var description: String = "L"
    
    public var rotationCount: Double = 0
    
    public var contacts: Contacts
    
    public var measurements: [CircuitUnit] = [1.00.henries()]
    
    public init(_ contacts: Direction...) {
        self.contacts = Contacts(contacts)
        self.rotationCount = getRotationCount(directions: contacts)
    }
    
    public mutating func rotate(_ rotation: Rotation) {
        self.contacts.rotate(rotation)
        updateRotationCount(count: &rotationCount, rotation: rotation)
    }
}

private func getRotationCount(positiveTerminal: Direction) -> Double {
    switch positiveTerminal {
    case .left:
        return 0
    case .up:
        return 1
    case .right:
        return 2
    case .down:
        return 3
    }
}

private func getRotationCount(directions: [Direction]) -> Double {
    if directions.contains(.right),  directions.contains(.left){
        return 0
    } else {
        return 1
    }
}

private func updateRotationCount(count: inout Double, rotation: Rotation) {
    switch rotation {
    case .clockwise:
        count += 1
    case .counterclockwise:
        count -= 1
    }
}


