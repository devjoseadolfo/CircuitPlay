import SwiftUI
import CircuitKit

public struct SignsView: View {
    private var positiveDirection: Direction
    private var negativeDirection: Direction { positiveDirection.opposite }
    
    public init(positiveDirection: Direction) {
        self.positiveDirection = positiveDirection
    }
    
    public var body: some View {
        GeometryReader{ geometry in
            SquareImageView("PositiveSign")
                .frame(width: geometry.size.width / 8, height: geometry.size.height / 8)
                .position(SignOffset(geometry: geometry, direction: positiveDirection).offset)
            SquareImageView("NegativeSign")
                .frame(width: geometry.size.width / 8, height: geometry.size.height / 8)
                .position(SignOffset(geometry: geometry, direction: negativeDirection).offset)
        }
    }
}

private struct SignOffset {
    private var geometry: GeometryProxy
    private var direction: Direction
    public var offset: CGPoint {
        switch direction {
        case .down:
            return CGPoint(x: 3 * geometry.size.height / 8, y: 7 * geometry.size.width / 8)
        case .up:
            return CGPoint(x: 3 * geometry.size.height / 8, y: geometry.size.width / 8)
        case .left:
            return CGPoint(x: 1 * geometry.size.width / 8, y: 3 * geometry.size.height / 8)
        case .right:
            return CGPoint(x: 7 * geometry.size.width / 8, y: 3 * geometry.size.height / 8)
        }
    }
    
    public init(geometry: GeometryProxy, direction: Direction) {
        self.geometry = geometry
        self.direction = direction
    }
}


