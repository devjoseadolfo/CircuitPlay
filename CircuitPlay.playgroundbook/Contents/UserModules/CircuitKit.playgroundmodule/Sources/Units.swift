import Foundation
public protocol CircuitUnit: CustomStringConvertible {
    var dimension: Dimension { get }
    var value: Double { get set }
    var unitPrefix: UnitPrefix { get }
    var base: BaseUnit { get }
    var prefixValue: Double { get }
}

protocol AddAndSub {
    static func + (rhs: Self, lhs: Self) -> Self
    static func - (rhs: Self, lhs: Self) -> Self
}

public func getPrefix(value: Double) -> UnitPrefix {
    if value.isZero { return .base }
    let log: Int = Int(floor(log10(abs(value)) / 3) * 3)
    return UnitPrefix(rawValue: log) ?? (log < 0 ? .pico : .tera)
}

func getDescription(_ unit: CircuitUnit) -> String {
    let fmt = NumberFormatter()
    fmt.numberStyle = .decimal
    fmt.minimumSignificantDigits = 3
    fmt.maximumSignificantDigits = 3
    fmt.string(for: unit.prefixValue)
    let finalValue = fmt.string(for: unit.prefixValue) ?? String(format: "%.2f", unit.prefixValue)
    return finalValue + " " + unit.unitPrefix.symbol + unit.base.symbol
}


public struct Volts: CircuitUnit, AddAndSub {
    public var dimension: Dimension = .voltage
    public var value: Double
    public var unitPrefix: UnitPrefix { getPrefix(value: value) }
    public var base: BaseUnit = .volt
    public var prefixValue: Double {
        let power = pow(10, Double(unitPrefix.rawValue))
        return unitPrefix == .base ? value : value / power
    }
    
    public init(_ value: Double = 0) {
        self.value = value
    }
    
    public var description: String { getDescription(self) }
    
    public static func + (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.value + rhs.value)
    }
    
    public static func - (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.value - rhs.value)
    }
}

public struct Ohms: CircuitUnit, AddAndSub {
    public var dimension: Dimension = .resistance
    public var value: Double
    public var unitPrefix: UnitPrefix { getPrefix(value: value) }
    public var base: BaseUnit = .ohm
    public var prefixValue: Double {
        let power = pow(10, Double(unitPrefix.rawValue))
        return unitPrefix == .base ? value : value / power
    }
    
    public init(_ value: Double = 0) {
        self.value = value
    }
    
    public var description: String { getDescription(self) }
    
    public static func + (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.value + rhs.value)
    }
    
    public static func - (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.value - rhs.value)
    }
}

public struct Amperes: CircuitUnit, AddAndSub {
    public var dimension: Dimension = .current
    public var value: Double
    public var unitPrefix: UnitPrefix { getPrefix(value: value) }
    public var base: BaseUnit = .ampere
    public var prefixValue: Double {
        let power = pow(10, Double(unitPrefix.rawValue))
        return unitPrefix == .base ? value : value / power
    }
    
    public init(_ value: Double = 0) {
        self.value = value
    }
    
    public var description: String { getDescription(self) }
    
    public static func + (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.value + rhs.value)
    }
    
    public static func - (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.value - rhs.value)
    }
}

public struct Watts: CircuitUnit, AddAndSub {
    public var dimension: Dimension = .power
    public var value: Double
    public var unitPrefix: UnitPrefix { getPrefix(value: value) }
    public var base: BaseUnit = .watt
    public var prefixValue: Double {
        let power = pow(10, Double(unitPrefix.rawValue))
        return unitPrefix == .base ? value : value / power
    }
    
    public init(_ value: Double = 0) {
        self.value = value
    }
    
    public var description: String { getDescription(self) }
    
    public static func + (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.value + rhs.value)
    }
    
    public static func - (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.value - rhs.value)
    }
}


public struct Hertz: CircuitUnit, AddAndSub {
    public var dimension: Dimension = .frequency
    public var value: Double
    public var unitPrefix: UnitPrefix { getPrefix(value: value) }
    public var base: BaseUnit = .hertz
    public var prefixValue: Double {
        let power = pow(10, Double(unitPrefix.rawValue))
        return unitPrefix == .base ? value : value / power
    }
    
    public init(_ value: Double = 0) {
        self.value = value
    }
    
    public var description: String { let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        fmt.maximumFractionDigits = 0
        fmt.string(for: prefixValue)
        let finalValue = fmt.string(for: prefixValue) ?? String(format: "%.2f", prefixValue)
        return finalValue + " " + unitPrefix.symbol + base.symbol
    }
    
    public static func + (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.value + rhs.value)
    }
    
    public static func - (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.value - rhs.value)
    }
}

public struct Henries: CircuitUnit, AddAndSub {
    public var dimension: Dimension = .inductance
    public var value: Double
    public var unitPrefix: UnitPrefix { getPrefix(value: value) }
    public var base: BaseUnit = .henry
    public var prefixValue: Double {
        let power = pow(10, Double(unitPrefix.rawValue))
        return unitPrefix == .base ? value : value / power
    }
    
    public init(_ value: Double = 0) {
        self.value = value
    }
    
    public var description: String { getDescription(self) }
    
    public static func + (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.value + rhs.value)
    }
    
    public static func - (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.value - rhs.value)
    }
}

public struct Farads: CircuitUnit, AddAndSub {
    public var dimension: Dimension = .capacitance
    public var value: Double
    public var unitPrefix: UnitPrefix { getPrefix(value: value) }
    public var base: BaseUnit = .farad
    public var prefixValue: Double {
        let power = pow(10, Double(unitPrefix.rawValue))
        return unitPrefix == .base ? value : value / power
    }
    
    public init(_ value: Double = 0) {
        self.value = value
    }
    
    public var description: String { getDescription(self) }
    
    public static func + (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.value + rhs.value)
    }
    
    public static func - (lhs: Self, rhs: Self) -> Self {
        return Self(lhs.value - rhs.value)
    }
}

extension Double {
    public func volts() -> Volts {
        return Volts(self)
    }
    public func amperes() -> Amperes {
        return Amperes(self)
    }
    public func ohms() -> Ohms {
        return Ohms(self)
    }
    public func watts() -> Watts {
        return Watts(self)
    }
    public func henries() -> Henries {
        return Henries(self)
    }
    public func farads() -> Farads {
        return Farads(self)
    }
    public func hertz() -> Hertz {
        return Hertz(self)
    }
}

