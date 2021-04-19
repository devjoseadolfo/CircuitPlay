import SwiftUI
import CircuitKit

public struct MeasurementView: View {
    @EnvironmentObject var envi: CircuitEnvironment
    @Binding private var measurement: CircuitUnit
    @State private var selected: Bool = false
    
    public init(measurement: Binding<CircuitUnit>) {
        self._measurement = measurement
    }
    
    @State var showPopover = false
    
    public var body: some View {
        Button {
            showPopover = true
        }
        label: {
            HStack(spacing: 4){
                Text(measurement.description)
                    .font(.system(size: 13.5, weight: .regular, design: .monospaced))
                if envi.currentState == .setup {
                    button
                }
            }
        }
        .foregroundColor(Color.primary)
        .frame(height: 20, alignment: .center)
        .padding(.horizontal, 4)
        .background(Color.gray.opacity(selected ? 0 : 0.25))
        .background(BlurView())
        .background(Color.white.opacity(selected ? 0.5 : 0))
        .cornerRadius(4)
        .animation(.spring(), value: selected)
        .popover(isPresented: $showPopover , arrowEdge: .top) { MeasurementEditView(measurement: $measurement, show: $showPopover) }
        .allowsHitTesting(envi.currentState == .setup)
    }
    
    var button: some View {
        Label("EDIT", systemImage: "pencil")
            .font(.system(size: 15, weight: .bold))
            .labelStyle(IconOnlyLabelStyle())
            .imageScale(.small)
            .aspectRatio(1.0, contentMode: .fit)
            .cornerRadius(4)
    }
}


