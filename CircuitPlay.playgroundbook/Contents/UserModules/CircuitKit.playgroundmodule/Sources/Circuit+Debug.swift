extension Circuit {
    public func debugLayout() {
        for row in circuitGrid.rows{
            var rowStr: String = ""
            for comp in row.slots {
                rowStr.append(comp.description)
                rowStr.append(" ")
            }
            print(rowStr)
        }
    }
    
    public mutating func stringGridTranslation(_ grid: [[String]]) {
        let translationGrid = grid.map({$0.map({$0.translateToComponent()})})
        for y in yRange {
            for x in xRange {
                circuitGrid.rows[y].slots[x].changeComponent(to: translationGrid[y][x])
            }
        }
    }
}

extension String {
    public func translateToComponent() -> CircuitComponent{
        switch self {
        case "│":
            return Wire(.up, .down)
        case "─":
            return Wire(.right, .left)
        case "┘":
            return Wire(.up, .left)
        case "└":
            return Wire(.up, .right)
        case "┐":
            return Wire(.left, .down)
        case "┌":
            return Wire(.right, .down)
        case "┴":
            return Wire(.up, .left, .right)
        case "┬":
            return Wire(.down, .right, .left)
        case "┤":
            return Wire(.up, .down, .left)
        case "├":
            return Wire(.up, .down, .right)
        case "┼":
            return Wire(.up, .down, .left, .right)
        case "R":
            return Resistor(.left, .right)
        case "V":
            return Battery(positive: .right, negative: .left)
        case "G":
            return Ground(.right)
        case "D":
            return Diode(positive: .right, negative: .left)
        case "L":
            return Inductor(.right, .left)
        case "C":
            return Capacitor(.right, .left)
        case "I":
            return CurrentSource(positive: .right, negative: .left)
        case "S":
            return VoltageSource(positive: .right, negative: .left)
        default:
            return BlankSpace()
        }
    }
}
