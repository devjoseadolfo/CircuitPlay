import Combine

public struct Circuit {
    public var rows: Int {
        didSet {
            setZIndex()
            setGridIndex()
        }
    }
    public var columns: Int {
        didSet {
            setZIndex()
            setGridIndex()
        }
    }
    
    let minRows: Int
    let minColumns: Int
    
    public var xRange: Range<Int> { 0..<columns }
    public var yRange: Range<Int> { 0..<rows }
    
    public var circuitGrid: Grid = Grid()
    
    public init(_ columns: Int, _ rows: Int) {
        self.rows = rows
        self.columns = columns
        self.minRows = rows
        self.minColumns = columns
        self.circuitGrid = createEmptyCircuitGrid(xR: 0..<columns, yR: 0..<rows)
        setZIndex()
        setGridIndex()
    }
    
    func createEmptyCircuitGrid(xR: Range<Int> , yR: Range<Int>) -> Grid {
        var emptyGrid: Grid = Grid()
        for _ in yR {
            var emptyRow: Row = Row()
            for _ in xR {
                emptyRow.append(Slot(component: BlankSpace()))
            }
            emptyGrid.append(emptyRow)
        }
        return emptyGrid
    }
    
    mutating func setZIndex() {
        let xCount = columns
        
        for y in yRange{
            for x in xRange {
                circuitGrid.rows[y].slots[x].zIndex = y * xCount + (xCount - x)
            }
        }
    }
    
    mutating func setGridIndex() {
        var zArray = [Int]()
        let xCount = columns
        
        for y in yRange{
            for x in xRange {
                circuitGrid.rows[y].slots[x].gridIndex = (x: x, y: y)
            }
        }
    }
}

