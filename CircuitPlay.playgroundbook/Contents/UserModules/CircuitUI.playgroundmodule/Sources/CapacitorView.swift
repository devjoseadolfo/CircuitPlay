import SwiftUI
import CircuitKit

public struct CapacitorView: View {
    private var capacitor: Capacitor
    
    private var rotationCount: Double { capacitor.rotationCount }
    
    private var isVertical: Bool { capacitor.contacts.orientation == .vertical}
    private var isFlippedY: Bool {
        return [-3.0,-2.0,1.0,2.0].contains(rotationCount.remainder(dividingBy: 4))
    }
    
    private var isFlippedX: Bool {
        return [-2.0,-1.0,2.0,3.0].contains(rotationCount.remainder(dividingBy: 4))
    }
    
    public init(capacitor: Capacitor) {
        self.capacitor = capacitor
    }
    
    public var body: some View {
        ZStack {
            WireShape {
                SquareImageView("CapacitorShape")
                    .rotation3DEffect( Angle(degrees: rotationCount * 90),
                                       axis: (x: 0, y: 0, z: 1))
                    .scaleEffect(1.5)
            } overlay: {
                SquareImageView("WireStraight")
                    .rotation3DEffect(isVertical ?
                                        Angle(degrees: 90) :
                                        Angle(degrees: 0), axis: (x: 0, y: 0, z: 1))
            }
            SquareImageView("CapacitorHead")
                .rotation3DEffect( Angle(degrees: isFlippedY ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                .rotation3DEffect( Angle(degrees: isFlippedX ? 180 : 0), axis: (x: 1, y: 0, z: 0))
                .rotation3DEffect( Angle(degrees: rotationCount * 90), axis: (x: 0, y: 0, z: 1))
        }
    }
}

