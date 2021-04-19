import SwiftUI
import CircuitKit

public struct CurrentSignView: View {
    private var direction: Direction
    
    public init(direction: Direction) {
        self.direction = direction
    }
    
    public var body: some View {
        GeometryReader{ geometry in
            SquareImageView("Arrow")
                .rotation3DEffect(.degrees(direction == .up || direction == .down ? 180 : 0), axis: (x: 1, y: 0, z: 0))
                .frame(width: geometry.size.width / 8, height: geometry.size.height / 8)
                .position(CGPoint(x: 7 * geometry.size.width / 8, y: 5 * geometry.size.height / 8) )
            SquareImageView("Arrow")
                .rotation3DEffect(.degrees(direction == .up || direction == .down ? 180 : 0), axis: (x: 1, y: 0, z: 0))
                .frame(width: geometry.size.width / 8, height: geometry.size.height / 8)
                .position(CGPoint(x: 1 * geometry.size.width / 8, y: 5 * geometry.size.height / 8))
        }.rotation3DEffect(.degrees(direction == .left ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        .rotation3DEffect(.degrees(direction == .up || direction == .down ? -90 : 0), axis: (x: 0, y: 0, z: 1))
        .rotation3DEffect(.degrees(direction == .down ? 180 : 0), axis: (x: 1, y: 0, z: 0))
    }
}
