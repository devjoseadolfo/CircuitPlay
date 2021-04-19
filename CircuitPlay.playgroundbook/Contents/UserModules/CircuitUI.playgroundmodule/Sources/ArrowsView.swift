import SwiftUI
import CircuitKit

public struct ArrowsView: View {
    private var direction: Direction
    private var rotationCount: Double
    private var isNegative: Bool
    private var isFlipped: Bool { direction == .right || direction == .down}
    public init(direction: Direction, rotationCount: Double, isNegative: Bool) {
        self.direction = direction
        self.rotationCount = rotationCount
        self.isNegative = isNegative
    }
    
    public var body: some View {
        GeometryReader{ geometry in
            SquareImageView("Arrow")
                .rotation3DEffect(Angle(degrees: isNegative ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                .rotation3DEffect(isFlipped ?
                                    Angle(degrees: 180) :
                                    Angle(degrees: 0), axis: (x: 1, y: 0, z: 0))
                .rotation3DEffect(Angle(degrees: rotationCount * 90), axis: (x: 0, y: 0, z: 1))
                .frame(width: geometry.size.width / 8, height: geometry.size.height / 8)
                .position(ArrowOffset(geometry: geometry, direction: direction).offset)
            SquareImageView("Arrow")
                .rotation3DEffect(Angle(degrees: isNegative ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                .rotation3DEffect(isFlipped ?
                                    Angle(degrees: 180) :
                                    Angle(degrees: 0), axis: (x: 1, y: 0, z: 0))
                .rotation3DEffect(Angle(degrees: rotationCount * 90), axis: (x: 0, y: 0, z: 1))
                .frame(width: geometry.size.width / 8, height: geometry.size.height / 8)
                .position(ArrowOffset(geometry: geometry, direction: direction.opposite).offset)
        }
    }
}

private struct ArrowOffset {
    private var geometry: GeometryProxy
    private var direction: Direction
    public var offset: CGPoint {
        switch direction {
        case .down:
            return CGPoint(x: 5 * geometry.size.height / 8, y: 7 * geometry.size.width / 8)
        case .up:
            return CGPoint(x: 5 * geometry.size.height / 8, y: geometry.size.width / 8)
        case .left:
            return CGPoint(x: 1 * geometry.size.width / 8, y: 5 * geometry.size.height / 8)
        case .right:
            return CGPoint(x: 7 * geometry.size.width / 8, y: 5 * geometry.size.height / 8)
        }
    }
    
    public init(geometry: GeometryProxy, direction: Direction) {
        self.geometry = geometry
        self.direction = direction
    }
}


