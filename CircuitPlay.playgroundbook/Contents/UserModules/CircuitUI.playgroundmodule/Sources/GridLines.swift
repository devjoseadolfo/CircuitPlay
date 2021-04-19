import SwiftUI

public struct GridLines: Shape {
    private var columns: Int
    private var rows: Int
    
    public init(columns: Int, rows: Int){
        self.columns = columns
        self.rows = rows
    }
    
    public func path(in rect: CGRect) -> Path {
        var xRange: ClosedRange<Int> = 0...(columns * 2)
        var yRange: ClosedRange<Int> = 0...(rows * 2)
        let offset: CGFloat = 0.5
        return Path { path in
            xRange.forEach { x in
                path.move(to: CGPoint(x: CGFloat(x * 64), y: -offset))
                path.addLine(to: CGPoint(x: CGFloat(x * 64), y: rect.height + offset))
            }
            yRange.forEach { y in
                path.move(to: CGPoint(x: -offset, y: CGFloat(y * 64)))
                path.addLine(to: CGPoint(x: rect.width + offset, y:  CGFloat(y * 64)))
            }
        }
    }
}

