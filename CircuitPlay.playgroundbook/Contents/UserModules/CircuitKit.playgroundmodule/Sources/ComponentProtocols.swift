import Foundation

public protocol CircuitComponent: CustomStringConvertible {
    var componentType: ComponentType { get }
    var connectionType: ConnectionType { get }
    var measurements: [CircuitUnit] { get set}
    mutating func rotate(_ rotation: Rotation)
}

public protocol Connectable: CircuitComponent {
    var contacts: Contacts { get }
    var rotationCount: Double { get }
}

public protocol Conductor: Connectable {}

public protocol TerminalDependent {
    var terminals: (positive: Direction, negative: Direction) { get }
}

extension Connectable {
    func setMeasurement(of unit: CircuitUnit, to value: Double) throws {
        guard let index = (measurements.firstIndex{$0.prefixValue == unit.prefixValue}) else {
            throw CircuitError.MeasurementNotFound }
        measurements[index]
    }
}

