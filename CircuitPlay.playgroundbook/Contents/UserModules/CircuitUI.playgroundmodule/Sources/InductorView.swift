import SwiftUI
import CircuitKit

public struct InductorView: View {
    private var inductor: Inductor
    
    private var rotationCount: Double { inductor.rotationCount }
    
    private var isVertical: Bool { inductor.contacts.orientation == .vertical}
    private var isFlippedY: Bool {
        return [-3.0,-2.0,1.0,2.0].contains(rotationCount.remainder(dividingBy: 4))
    }
    
    private var isFlippedX: Bool {
        return [-2.0,-1.0,2.0,3.0].contains(rotationCount.remainder(dividingBy: 4))
    }
    
    public init(inductor: Inductor) {
        self.inductor = inductor
    }
    
    public var body: some View {
        WireShape {
            SquareImageView("InductorShape")
                .rotation3DEffect( Angle(degrees: rotationCount * 90),
                                   axis: (x: 0, y: 0, z: 1))
                .scaleEffect(1.5)
        } overlay: {
            SquareImageView("Inductor")
                .rotation3DEffect( Angle(degrees: isFlippedY ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                .rotation3DEffect( Angle(degrees: isFlippedX ? 180 : 0), axis: (x: 1, y: 0, z: 0))
                .rotation3DEffect( Angle(degrees: isVertical ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                .rotation3DEffect( Angle(degrees: rotationCount * 90), axis: (x: 0, y: 0, z: 1))
        }
        
    }
}


