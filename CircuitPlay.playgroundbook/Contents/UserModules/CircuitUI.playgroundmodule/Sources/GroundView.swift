import CircuitKit
import SwiftUI

public struct GroundView: View {
    private var ground: Ground
    
    private var rotationCount: Double { ground.rotationCount }
    private var rotatingRemainder: Double {  rotationCount.truncatingRemainder(dividingBy: 4.0) }
    private var isFlipped: Bool {
        [-1.0,-2.0,2.0,3.0].contains(rotationCount.remainder(dividingBy: 4))
    }
    
    public init(ground: Ground) {
        self.ground = ground
    }
    
    public var body: some View {
        ZStack {
            wireGround
            groundNode
        }
    }
    
    var wireGround: some View {
        WireShape(mask: {
            SquareImageView("WireGroundShape")
                .rotation3DEffect( Angle(degrees: rotationCount * 90),
                                   axis: (x: 0, y: 0, z: 1))
                .scaleEffect(1.5)
        }, overlay: {
            switch rotatingRemainder {
            case 1, -3:
                SquareImageView("WireGround2")
                    .rotation3DEffect( Angle(degrees: 90),
                                       axis: (x: 0, y: 0, z: 1))
                    .rotation3DEffect( Angle(degrees: 180),
                                       axis: (x: 0, y: 1, z: 0))
            case 2, -2:
                SquareImageView("WireGround2")
                    .rotation3DEffect( Angle(degrees: 180),
                                       axis: (x: 0, y: 0, z: 1))
            case 3, -1:
                SquareImageView("WireGround1")
                    .rotation3DEffect( Angle(degrees: -90),
                                       axis: (x: 0, y: 0, z: 1))
                    .rotation3DEffect( Angle(degrees: 180),
                                       axis: (x: 0, y: 1, z: 0))
            default:
                SquareImageView("WireGround1")
            }
        })
    }
    
    var groundNode: some View {
        GeometryReader { geo in
            ZStack {
                SquareImageView("Ground3")
                    .rotation3DEffect(Angle(degrees: rotationCount * 90), axis: (x: 0, y: 0, z: 1))
                    .rotation3DEffect([1, -3, 2, -2].contains(rotatingRemainder) ? .degrees(180) : .zero, axis: (x: 1, y: 0, z: 0))
                    .rotation3DEffect([2, -2, 3, -1].contains(rotatingRemainder) ? .degrees(180) : .zero, axis: (x: 0, y: 1, z: 0))
                    .offset(getOffsetGround3(geo.size))
                SquareImageView("Ground2")
                    .rotation3DEffect(Angle(degrees: rotationCount * 90), axis: (x: 0, y: 0, z: 1))
                    .rotation3DEffect([1, -3, 2, -2].contains(rotatingRemainder) ? .degrees(180) : .zero, axis: (x: 1, y: 0, z: 0))
                    .rotation3DEffect([2, -2, 3, -1].contains(rotatingRemainder) ? .degrees(180) : .zero, axis: (x: 0, y: 1, z: 0))
                SquareImageView("Ground1")
                    .rotation3DEffect(Angle(degrees: rotationCount * 90), axis: (x: 0, y: 0, z: 1))
                    .rotation3DEffect([1, -3, 2, -2].contains(rotatingRemainder) ? .degrees(180) : .zero, axis: (x: 1, y: 0, z: 0))
                    .rotation3DEffect([2, -2, 3, -1].contains(rotatingRemainder) ? .degrees(180) : .zero, axis: (x: 0, y: 1, z: 0))
                    .offset(getOffsetGround1(geo.size))
            }.position(x: geo.frame(in: .local).midX, y:  geo.frame(in: .local).midY)
        }.aspectRatio(1,contentMode: .fit )
    }
    
    func getOffsetGround1(_ size: CGSize) -> CGSize {
        switch rotatingRemainder {
        case 1, -3:
            return CGSize(width: 0, height: -3 * size.height / 32)
        case 2, -2:
            return CGSize(width: 3 * size.width / 32, height: 0)
        case 3, -1:
            return CGSize(width: 0, height: 3 * size.height / 32)
        default:
            return CGSize(width: -3 * size.width / 32, height: 0)
        }
    }
    
    func getOffsetGround3(_ size: CGSize) -> CGSize {
        switch rotatingRemainder {
        case 1, -3:
            return CGSize(width: 0, height: 3 * size.height / 32)
        case 2, -2:
            return CGSize(width: -3 * size.width / 32, height: 0)
        case 3, -1:
            return CGSize(width: 0, height: -3 * size.height / 32)
        default:
            return CGSize(width: 3 * size.width / 32, height: 0)
        }
    }
}


