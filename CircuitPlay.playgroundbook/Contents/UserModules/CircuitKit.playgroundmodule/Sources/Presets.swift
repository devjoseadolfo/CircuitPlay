public enum CircuitPreset {
    case blank
    case ohmsLaw
    case series
    case parallel
    case resistorCapacitor
    case resistorInductor
    
    public var circuit: Circuit {
        switch self {
        case .blank:
            var blankCircuit = Circuit(3, 3)
            return blankCircuit
        case .ohmsLaw:
            let circuit: [[String]] = [["G","R","┐"],
                                       [" "," ","│",],
                                       ["G","V","┘"]]
            
            var translatedCircuit = Circuit(3, 3)
            translatedCircuit.stringGridTranslation(circuit)
            return translatedCircuit
        case .series:
            let circuit: [[String]] = [["G","R","┐"],
                                       [" "," ","R",],
                                       ["G","V","┘"]]
            
            var translatedCircuit = Circuit(3, 3)
            translatedCircuit.stringGridTranslation(circuit)
            translatedCircuit.circuitGrid[(2,1)].component.rotate(.clockwise)
            return translatedCircuit
        case .parallel:
            let circuit: [[String]] = [["G","R","┐"],
                                       ["G","R","┤"],
                                       ["G","V","┘"]]
            
            var translatedCircuit = Circuit(3, 3)
            translatedCircuit.stringGridTranslation(circuit)
            return translatedCircuit
        case .resistorCapacitor:
            let circuit: [[String]] = [["G","C","┐"],
                                       [" "," ","R",],
                                       ["G","V","┘"]]
            
            var translatedCircuit = Circuit(3, 3)
            translatedCircuit.stringGridTranslation(circuit)
            translatedCircuit.circuitGrid[(2,1)].component.rotate(.clockwise)
            return translatedCircuit
        case .resistorInductor:
            let circuit: [[String]] = [["G","L","┐"],
                                       [" "," ","R",],
                                       ["G","V","┘"]]
            
            var translatedCircuit = Circuit(3, 3)
            translatedCircuit.stringGridTranslation(circuit)
            translatedCircuit.circuitGrid[(2,1)].component.rotate(.clockwise)
            return translatedCircuit
        }
    }
}

