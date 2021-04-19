public enum ComponentType {
    case wire
    case spacer
    case ground
    case battery, voltageSource
    case currentSource
    case resistor
    case inductor, capacitor
    case diode
    
    public var name: String {
        switch self {
        case .wire:
            return "Wire"
        case .resistor:
            return "Resistor"
        case .battery:
            return "Voltage \n Source"
        case .ground:
            return "Ground"
        case .diode:
            return "Diode"
        case .inductor:
            return "Inductor"
        case .capacitor:
            return "Capacitor"
        case .currentSource:
            return "Current \n Source"
        case .voltageSource:
            return "Voltage \n Source"
        default:
            return "Unnamed"
        }
    }
    
    public var imageName: String {
        switch self {
        case .battery:
            return "Battery"
        case .currentSource, .voltageSource:
            return "Source"
        case .resistor:
            return "Resistor"
        case .diode:
            return "Diode"
        case .inductor:
            return "Inductor"
        case .capacitor:
            return "Capacitor"
        default:
            return ""
        }
    }
}

public enum SignalType: String, CaseIterable {
    case direct
    case pulse
    case sine
    
    public var rawValue: String {
        self.rawValue.capitalized
    }
}
