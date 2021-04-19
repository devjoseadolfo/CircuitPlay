import SwiftUI
import CircuitKit

public struct ComponentView: View {
    private var component: CircuitComponent
    
    public init(component: CircuitComponent) {
        self.component = component
    }
    
    public var body: some View {
        switch component.componentType {
        case .wire:
            WireView(wire: component as! Wire)
        case .battery:
            WiredComponentView(component: component as! Connectable)
        case .resistor:
            WiredComponentView(component: component as! Connectable)
        case .currentSource:
            WiredComponentView(component: component as! Connectable)
        case .ground:
            GroundView(ground: component as! Ground)
        case .capacitor:
            CapacitorView(capacitor: component as! Capacitor)
        case .inductor:
            InductorView(inductor: component as! Inductor)
        default:
            Rectangle()
                .fill(Color.white.opacity(0.0001))
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: .infinity, height: .infinity)
        }
    }
}

