

public enum Dimension: String, Identifiable {
    case voltage
    case resistance
    case current
    case power
    case frequency
    case inductance
    case capacitance
    
    public var id: String {
        self.rawValue.capitalized
    }
}

public enum UnitPrefix: Int {
    case tera = 12
    case giga = 9
    case mega = 6
    case kilo = 3
    case base = 0
    case milli = -3
    case micro = -6
    case nano = -9
    case pico = -12
    
    public var symbol: String {
        switch self {
        case .tera:
            return  "T"
        case .giga:
            return "G"
        case .mega:
            return "M"
        case .kilo:
            return "k"
        case .base:
            return ""
        case .milli:
            return "m"
        case .micro:
            return "μ"
        case .nano:
            return "n"
        case .pico:
            return "p"
        }
    }
}

public enum BaseUnit {
    case volt
    case ohm
    case ampere
    case watt
    case hertz
    case henry
    case farad
    
    public var symbol: String {
        switch self {
        case .volt:
            return "V"
        case .ampere:
            return "A"
        case .ohm:
            return "Ω"
        case .watt:
            return "W"
        case .hertz:
            return "Hz"
        case .henry:
            return "H"
        case .farad:
            return "F"
        }
    }
    
    public func createUnit(from value: Double) -> CircuitUnit {
        switch self {
        case .volt:
            return value.volts()
        case .ampere:
            return value.amperes()
        case .ohm:
            return value.ohms()
        case .watt:
            return value.watts()
        case .hertz:
            return value.hertz()
        case .henry:
            return value.henries()
        case .farad:
            return value.farads()
        }
    }
}
