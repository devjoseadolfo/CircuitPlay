import SwiftUI
import CircuitKit

public struct DesignSideButtonsView: View {
    @EnvironmentObject var envi: CircuitEnvironment
    
    public var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                guard let selectedSlot = envi.selectedSlot else { return }
                envi.circuit.circuitGrid[selectedSlot].component.rotate(.clockwise)
            }){
                Label("Rotate Right", systemImage: "rotate.right")
                    .labelStyle(IconOnlyLabelStyle())
            }.buttonStyle(SideButtonStyle())
            Button(action: {
                guard let selectedSlot = envi.selectedSlot else { return }
                envi.circuit.circuitGrid[selectedSlot].component.rotate(.counterclockwise)
            }){
                Label("Rotate Left", systemImage: "rotate.left")
                    .labelStyle(IconOnlyLabelStyle())
            }.buttonStyle(SideButtonStyle())
            Button(action: {
                guard let selectedSlot = envi.selectedSlot else { return }
                envi.circuit.circuitGrid[selectedSlot].component = BlankSpace()
                envi.selectedSlot = nil
            }){
                Label("Trash", systemImage: "trash")
                    .labelStyle(IconOnlyLabelStyle())
            }.buttonStyle(SideButtonStyle())
        }.background(BlurView())
        .cornerRadius(8)
    }
}

public struct SideButtonStyle: ButtonStyle {
    public init(){}
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.25 : 1.0)
            .frame(width: 24, height: 24, alignment: .center)
            .aspectRatio(1.0, contentMode: .fit)
            .padding(4)
            .background(configuration.isPressed ? Color.blue.opacity(0.5) : Color.gray.opacity(0.25))
            .shadow(radius: configuration.isPressed ? 7.5 : 0)
            .animation(.linear, value: configuration.isPressed)
    }
}
