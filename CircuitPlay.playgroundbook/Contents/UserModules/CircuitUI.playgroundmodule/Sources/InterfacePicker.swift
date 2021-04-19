import SwiftUI

public struct InterfacePicker: View {
    @EnvironmentObject var envi: CircuitEnvironment
    
    public var body: some View {
        GeometryReader { geo in
            ZStack{
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.5))
                    .frame(width: 36, height: 36, alignment: .center)
                    .opacity(envi.arMode ? 1 : 0)
                Toggle("", isOn: $envi.arMode)
                    .toggleStyle(CheckMarkToggleStyle())
            }
            .frame(width: 52, height: 52, alignment: .center)
            .background(BlurView())
            .background(Color.gray.opacity(0.25))
            .cornerRadius(12)
            .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).minY + 192)
        }.animation(.spring(), value: envi.currentState)
    }
}

struct CheckMarkToggleStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Button(action: { configuration.isOn.toggle() } )
            {
                Image(systemName: "arkit")
                    .foregroundColor(Color.primary)
            }
        }
        .font(.title)
        .padding(.horizontal)
    }
}
