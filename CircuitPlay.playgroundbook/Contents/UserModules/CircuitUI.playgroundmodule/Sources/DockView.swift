import SwiftUI
import CircuitKit

public struct DockView: View {
    @EnvironmentObject var envi: CircuitEnvironment
    @State private var dockOrigin: CGFloat = 0
    @State private var dockSlots: [Slot] = [Slot(component: Wire(.left, .right)),
                                     Slot(component: Wire(.up, .right)),
                                     Slot(component: Wire(.up, .right, .left)),
                                     Slot(component: Wire(.up, .right, .left, .down)),
                                     Slot(component: Battery(positive: .right, negative: .left)),
                                     Slot(component: Resistor(.left, .right)),
                                     Slot(component: Ground(.up)),
                                     Slot(component: CurrentSource(positive: .right, negative: .left)),
                                     Slot(component: Capacitor(.left, .right)),
                                     Slot(component: Inductor(.left, .right))]
    @State var showDock: Bool = true
    
    public init(){}
    public var body: some View {
        GeometryReader { geo in
            ChevronButton($showDock, direction: .up)
                .position(x: showDock ? geo.frame(in: .global).midX - 260 : geo.frame(in: .global).midX, y: showDock ? geo.frame(in: .global).maxY - 270 : geo.frame(in: .global).maxY - 115
                )
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top,spacing: 16) {
                    ForEach(dockSlots) { slot in
                        CardView(slot: slot)
                            .simultaneousGesture(DragGesture(coordinateSpace: .global)
                                                    .onChanged { value in
                                                        envi.dragPosition = envi.popoverShown ? nil : value.location
                                                        envi.selectedSlot = nil
                                                        envi.draggedDock = slot.component
                                                    }
                                                    .onEnded{ finalValue in
                                                        envi.dragPosition = nil
                                                        let finalDragIndex = envi.pointToGridIndex(point: finalValue.location, in: envi.gridRect)
                                                        guard let finalIndex = finalDragIndex else { return }
                                                        envi.circuit.circuitGrid[finalIndex].changeComponent(to: slot.component)
                                                    }
                            )
                            .allowsHitTesting(envi.dragPosition == nil)
                    }
                }
                .overlay(
                    GeometryReader { geo in
                        Color.clear
                            .onChange(of: geo.frame(in: .global).origin, perform: {value in
                                DispatchQueue.main.async {
                                    envi.dockOrigin = geo.frame(in: .global).origin.x
                                }
                            })
                    }
                )
                .padding(16)
            }
            .background(BlurView())
            .background(Color.gray.opacity(0.25))
            .cornerRadius(16)
            .padding(16)
            .frame(maxWidth: 600, alignment: .center)
            .position(x: geo.frame(in: .global).midX, y: showDock ? geo.frame(in: .global).maxY - 170 : geo.frame(in: .global).maxY + 200)
        }.animation(.spring(), value: showDock)
    }
}

public struct CardView: View {
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var envi: CircuitEnvironment
    var slot: Slot
    
    public var body: some View {
        VStack {
            ComponentView(component: slot.component)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.clear.getBackground(for: colorScheme), lineWidth: 4))
                .transition(.opacity)
                .frame(width: 72, height: 72, alignment: .center)
            Text(slot.component.componentType.name)
                .font(.system(size: 15))
        }
    }
}


