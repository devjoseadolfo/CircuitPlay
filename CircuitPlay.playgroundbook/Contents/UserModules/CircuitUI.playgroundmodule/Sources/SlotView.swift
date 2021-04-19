import SwiftUI
import CircuitKit

public struct GridSlotView: View {
    @EnvironmentObject var envi: CircuitEnvironment
    @Binding private var slot: Slot
    @Environment (\.colorScheme) private var colorScheme: ColorScheme
    @State private var modelIndex: Int?
    @State private var nodeIndex: Int?
    private var showDesignSideButton: Bool { slot.selected && envi.currentState == .design }
    
    public init(slot: Binding<Slot>) {
        self._slot = slot
    }
    
    var isVertical: Bool {
        guard slot.component is Connectable else { return false }
        let component = slot.component as! Connectable
        if slot.component is Capacitor {
            return component.contacts.orientation != .vertical
        }
        return component.contacts.orientation == .vertical
        }
    
    public var body: some View {
        ZStack {
            Group {
                background
                main
                stroke
            }.allowsHitTesting(envi.currentState != .setup)
            if envi.currentState == .play {
                if let index = modelIndex,
                   let network = envi.network,
                   let model = network.models[index],
                   let direction = model.currentGoing,
                   model.current != 0 {
                    Group {
                        CurrentSignView(direction: direction)
                        if !(slot.component is Battery || slot.component is CurrentSource) {
                            SignsView(positiveDirection: direction.opposite)
                        }
                    }
                    .shadow(radius: envi.currentState == .design ? 0 : 2.5,
                             x: envi.currentState == .design ? 0 : -2.5,
                             y: envi.currentState == .design ? 0 : 2.5)
                    GeometryReader { geo in
                        NameView(name: model.description)
                            .rotationEffect(isVertical ? .degrees(-90) : .zero)
                            .position(x: isVertical ? 1 * geo.frame(in: .local).width / 4 : geo.frame(in: .local).midX,
                                      y: isVertical ? geo.frame(in: .local).midY : 1 * geo.frame(in: .local).height / 4)
                            .offset(x: isVertical && slot.component.componentType.imageName == "Source" ? -geo.frame(in: .local).width / 8 : 0, y: !isVertical && slot.component.componentType.imageName == "Source" ? -geo.frame(in: .local).height / 8 : 0)
                    }
                }
            }
            if envi.currentState != .design {
                measurement
            }
        }
        .frame(alignment: .center)
        .overlay(sideOverlay)
        .offset(x: slot.selected && envi.currentState == .design ? 8 : 0,
                y: slot.selected && envi.currentState == .design ? -8 : 0)
        .onTapGesture(count: 1) {
            slot.selected = !slot.selected
            envi.selectedSlot = slot.selected ? slot.gridIndex : nil
        }
        .allowsHitTesting(slot.component.componentType != .spacer)
        .onChange(of: envi.currentState) {
            if $0 == .play {
                modelIndex = envi.getModelIndexAt(location: slot.gridIndex)
                nodeIndex = envi.getNodeIndexAt(location: slot.gridIndex)
            }
        }
    }
    
    var main: some View {
        ComponentView(component: slot.component)
            .transition(.fadeAndScale)
            .shadow(radius: envi.currentState == .design ? 0 : 2.5,
                    x: envi.currentState == .design ? 0 : -2.5,
                    y: envi.currentState == .design ? 0 : 2.5)
    }
    
    var stroke: some View {
        RoundedRectangle(cornerRadius: envi.currentState == .design ? 8 : 0)
            .stroke(slot.gridIndex == envi.dragGridIndex ?? Location(-1,-1) ? Color.green : Color.clear.getBackground(for: colorScheme),
                        lineWidth: envi.currentState == .design ? 4 : 0)
                
    }
    
    var background: some View {
        GeometryReader { geo in
            RoundedRectangle(cornerRadius: envi.currentState == .setup ? 0 : 8)
                .fill(slot.selected ? Color(red: 0.353, green: 0.521, blue: 0.652, opacity: 1.000) : Color.clear)
                .shadow(
                    radius: slot.selected && envi.currentState == .design ? 10 : 0,
                    x: slot.selected && envi.currentState == .design ? -5 : 0,
                    y: slot.selected && envi.currentState == .design ? 5 : 0)
                .frame(width: geo.size.width - 1, height: geo.size.height - 1, alignment: .center)
                .offset(x: 0.5, y: 0.5)
        }
    }
    var sideOverlay: some View {
        DesignSideButtonsView()
            .offset(x: showDesignSideButton ? 88: 60)
            .opacity(showDesignSideButton ? 1 : 0)
            .allowsHitTesting(showDesignSideButton)
    }
    
    var measurement: some View {
        GeometryReader { geo in
            if !slot.component.measurements.isEmpty {
                MeasurementView(measurement: $slot.component.measurements[0])
                    .rotationEffect(isVertical ? .degrees(-90) : .zero)
                    .position(x: isVertical ? 3 * geo.frame(in: .local).width / 4 : geo.frame(in: .local).midX,
                              y: isVertical ? geo.frame(in: .local).midY : 3 * geo.frame(in: .local).height / 4)
                    .offset(x: isVertical && slot.component.componentType.imageName == "Source" ? geo.frame(in: .local).width / 8 : 0, y: !isVertical && slot.component.componentType.imageName == "Source" ? geo.frame(in: .local).height / 8 : 0)
                    
            }
        }
    }
    
    var name: some View {
        GeometryReader { geo in
            if !slot.component.measurements.isEmpty {
                MeasurementView(measurement: $slot.component.measurements[0])
                    .rotationEffect(isVertical ? .degrees(-90) : .zero)
                    .position(x: isVertical ? 3 * geo.frame(in: .local).width / 4 : geo.frame(in: .local).midX,
                              y: isVertical ? geo.frame(in: .local).midY : 3 * geo.frame(in: .local).height / 4)
                    .offset(x: isVertical && slot.component.componentType.imageName == "Source" ? geo.frame(in: .local).width / 8 : 0, y: !isVertical && slot.component.componentType.imageName == "Source" ? geo.frame(in: .local).height / 8 : 0)
                
            }
        }
    }
}

extension AnyTransition {
    static var fadeAndScale: AnyTransition {
        AnyTransition.opacity.combined(with: .scale)
    }
}

