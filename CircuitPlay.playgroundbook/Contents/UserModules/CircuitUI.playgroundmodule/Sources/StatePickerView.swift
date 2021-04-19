import SwiftUI

public struct StatePicker: View {
    @EnvironmentObject var envi: CircuitEnvironment
    
    public var body: some View {
        GeometryReader { geo in
            ZStack{
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.5))
                    .offset(x: envi.currentState == .design ? -88 : 0)
                    .offset(x: envi.currentState == .play ? 88 : 0)
                    .frame(width: 80, height: 40, alignment: .center)
                HStack{
                    Button(action: {envi.currentState = .design} ) {
                        Text("DESIGN")
                            .fontWeight(.heavy)
                    }.buttonStyle(PickerButtonStyle())
                    Button(action: {envi.currentState = .setup} ) {
                        Text("SETUP")
                            .fontWeight(.heavy)
                    }.buttonStyle(PickerButtonStyle())
                    Button(action: {envi.solveCircuit()} ) {
                        Text("SOLVE")
                            .fontWeight(.heavy)
                    }.buttonStyle(PickerButtonStyle())
                }.padding(8)
            }.background(BlurView())
            .background(Color.gray.opacity(0.25))
            .cornerRadius(12)
            .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).minY + 120)
        }.animation(.spring(), value: envi.currentState)
    }
}

struct PickerButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 72, height: 32, alignment: .center)
            .aspectRatio(1.0, contentMode: .fit)
            .scaleEffect(configuration.isPressed ? 1.0 : 1.0)
            .shadow(radius: configuration.isPressed ? 7.5 : 0)
            .animation(.linear, value: configuration.isPressed)
            .padding(4)
            .foregroundColor(Color.primary)
    }
}

