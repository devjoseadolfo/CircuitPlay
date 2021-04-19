import SwiftUI
import CircuitKit

public struct WiredComponentView: View {
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    
    private var component: Connectable
    
    private var rotationCount: Double { component.rotationCount }
    
    private var isFlipped: Bool {
        if let terminalComponent = component as? TerminalDependent {
            return terminalComponent.terminals.positive == .down || terminalComponent.terminals.positive == .right
        }
        return [-1.0,-2.0,2.0,3.0].contains(rotationCount.remainder(dividingBy: 4))
    }
    private var flippable: Bool { component.componentType.imageName != "Source" }
    
    public init(component: Connectable){
        self.component = component
    }
    
    public var body: some View {
        ZStack {
            CondensedWireShape(rotationCount: rotationCount)
            SquareImageView(component.componentType.imageName)
                .rotation3DEffect(isFlipped && flippable ?
                                    Angle(degrees: 180) :
                                    Angle(degrees: 0), axis: (x: 1, y: 0, z: 0))
                .rotation3DEffect(Angle(degrees: flippable ? rotationCount * 90 : 0), axis: (x: 0, y: 0, z: 1))
            if let currentSource = component as? CurrentSource {
                var current = currentSource.measurements[0].value
                if current != 0 {
                    ArrowsView(direction: currentSource.terminals.positive, rotationCount: currentSource.rotationCount, isNegative: current > 0)
                }
            }
            if let terminalComponent = component as? TerminalDependent {
                SignsView(positiveDirection: terminalComponent.terminals.positive)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct CondensedWireShape: View {
    private var rotationCount: Double
    private var rotatingRemainder: Double {  rotationCount.truncatingRemainder(dividingBy: 2.0) }
    
    init(rotationCount: Double) {
        self.rotationCount = rotationCount
    }
    var body: some View {
        ZStack {
                mainShape
                    .overlay(
                        overlay
                            .mask(
                                mainShape
                            )
                    )
                    .mask(Rectangle())
        }
    }
    
    private var mainShape: some View {
        SquareImageView("WireCondensedShape")
            .rotation3DEffect( Angle(degrees: rotationCount * 90),
                               axis: (x: 0, y: 0, z: 1))
            .scaleEffect(1.5)
    }
    
    private var overlay: some View {
        Group {
            switch rotatingRemainder {
            case 0:
                SquareImageView("WireStraight")
            default:
                SquareImageView("WireStraight")
                    .rotation3DEffect( Angle(degrees: 90),
                                       axis: (x: 0, y: 0, z: 1))
            }
        }
    }
}

