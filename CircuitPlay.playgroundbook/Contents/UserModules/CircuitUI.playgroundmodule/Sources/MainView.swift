import SwiftUI
import CircuitKit
import CircuitReality

public struct MainView: View {
    @EnvironmentObject var envi: CircuitEnvironment
    
    public init(){}
    
    public var body: some View {
        ZStack {
            if envi.currentState == .play && envi.arMode {
                ARViewContainer()
            } else {
                GridView()
            }
            StatePicker()
            if envi.currentState == .play {
                InterfacePicker()
            }
            DockView()
                .opacity(envi.currentState == .design ? 1.0 : 0.0)
                .allowsHitTesting(envi.currentState == .design)
                .offset(y: envi.currentState == .design ? 0.0 : 120)
                .animation(.spring(), value: envi.currentState)
            if let position = envi.dragPosition {
                HoverView()
                    .position(position)
            }
            if envi.currentState == .play {
                InfoView()
                NextStepView()
            }
        }.animation(.linear, value: envi.currentState)
    }
}

public struct HoverView: View {
    @EnvironmentObject var envi: CircuitEnvironment
    
    public init(){}
    
    public var body: some View {
        if envi.firstDragIndex == nil, let draggedDock = envi.draggedDock {
            ComponentView(component: draggedDock)
                .frame(width: 72, height: 72, alignment: .center)
                .background(BlurView())
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(envi.dragState == .valid ? Color.green : Color.red, lineWidth: 4)
                )
                .shadow(radius: 8)
                .animation(.linear(duration: 0.1875), value: envi.dragState)
        }
        if let firstDragIndex = envi.firstDragIndex {
            ComponentView(component: envi.circuit.circuitGrid[firstDragIndex].component)
                .frame(width: 72, height: 72, alignment: .center)
                .background(BlurView())
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(envi.dragState == .valid ? Color.green : Color.red, lineWidth: 4)
                )
                .shadow(radius: 8)
                .animation(.linear(duration: 0.1875), value: envi.dragState)
        }
    }
}

