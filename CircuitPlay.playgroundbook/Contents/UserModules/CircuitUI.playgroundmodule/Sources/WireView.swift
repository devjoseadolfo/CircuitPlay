import SwiftUI
import CircuitKit

public struct WireView: View {
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    private var wire: Wire
    
    private var rotationCount: Double { wire.rotationCount }
    
    public init(wire: Wire) {
        self.wire = wire
    }
    
    public var body: some View {
        Group {
            switch wire.connectionType {
                case .straight:
                    WireStraightShape(wire)
                case .corner:
                    WireCornerShape(wire)
                case .tshape:
                    WireTshapeShape(wire)
                case .cross:
                    WireCrossShape(wire)
                default:
                    EmptyView()
                }
        }.mask(LinearGradient(gradient: Gradient(colors: [Color.black, Color.white]), startPoint: .leading, endPoint: .trailing))
    }
}

public struct WireShape<Mask: View, Overlay: View>: View {
    let mask: Mask
    let overlay: Overlay
    
    public init(@ViewBuilder mask: () -> Mask, @ViewBuilder overlay: () -> Overlay) {
        self.mask = mask()
        self.overlay = overlay()
    }
    
    public var body: some View {
        mask
            .overlay(
                overlay
                    .mask(
                        mask
                    )
            )
            .clipped()
    }
}

struct WireStraightShape: View {
    private var wire: Wire
    private var rotationCount: Double { wire.rotationCount }
    private var rotatingRemainder: Double {  rotationCount.truncatingRemainder(dividingBy: 2.0) }
    
    init(_ wire: Wire) {
        self.wire = wire
    }
    
    var body: some View {
        WireShape(mask: {
            SquareImageView("WireStraightShape")
                .rotation3DEffect( Angle(degrees: rotationCount * 90),
                                   axis: (x: 0, y: 0, z: 1))
                .scaleEffect(1.5)
        }, overlay: {
            switch rotatingRemainder {
            case 0:
                SquareImageView("WireStraight")
            default:
                SquareImageView("WireStraight")
                    .rotation3DEffect( Angle(degrees: 90),
                                       axis: (x: 0, y: 0, z: 1))
            }
        })
    }
}

struct WireCornerShape: View {
    private var wire: Wire
    private var rotationCount: Double { wire.rotationCount }
    private var rotatingRemainder: Double {  rotationCount.truncatingRemainder(dividingBy: 4.0) }
    
    init(_ wire: Wire) {
        self.wire = wire
    }
    
    var body: some View {
        WireShape(mask: {
            SquareImageView("WireCornerShape")
                .rotation3DEffect( Angle(degrees: rotationCount * 90),
                                   axis: (x: 0, y: 0, z: 1))
                .scaleEffect(1.5)
        }, overlay: {
            switch rotatingRemainder {
            case 1, -3:
                SquareImageView("WireCornerUR")
            case 2, -2:
                SquareImageView("WireCornerDR")
            case 3, -1:
                SquareImageView("WireCornerDL")
            default:
                SquareImageView("WireCornerUL")
            }
        })
    }
}

struct WireTshapeShape: View {
    private var wire: Wire
    private var rotationCount: Double { wire.rotationCount }
    private var rotatingRemainder: Double { rotationCount.truncatingRemainder(dividingBy: 4.0) }
    
    init(_ wire: Wire) {
        self.wire = wire
    }
    
    var body: some View {
        WireShape(mask: {
            SquareImageView("WireTshapeShape")
                .rotation3DEffect( Angle(degrees: rotationCount * 90),
                                   axis: (x: 0, y: 0, z: 1))
                .scaleEffect(1.5)
        }, overlay: {
            switch rotatingRemainder {
            case 1, -3:
                SquareImageView("WireTshapeULR")
            case 2, -2:
                SquareImageView("WireTshapeDUR")
            case 3, -1:
                SquareImageView("WireTshapeDLR")
            default:
                SquareImageView("WireTshapeDUL")
            }
        })
    }
}

struct WireCrossShape: View {
    private var wire: Wire
    
    init(_ wire: Wire) {
        self.wire = wire
    }
    
    var body: some View {
        WireShape(mask: {
            SquareImageView("WireCrossShape")
                .scaleEffect(1.5)
                .rotationEffect(.degrees(90 * wire.rotationCount))
        }, overlay: {
            SquareImageView("WireCross")
        })
    }
}
