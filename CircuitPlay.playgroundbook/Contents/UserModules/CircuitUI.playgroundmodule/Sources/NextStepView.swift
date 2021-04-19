import SwiftUI

public struct NextStepView: View {
    @EnvironmentObject var envi: CircuitEnvironment
    public init() {}
    public var body: some View {
        GeometryReader { geo in
            Button(action: {
                do {
                    try envi.network?.solveNetwork()
                } catch {
                    
                }
            }){
                Label("Next Time Step", systemImage: "forward.fill")
                    .foregroundColor(Color.primary)
            }
            .buttonStyle(StepButtonStyle())
            .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).maxY - 135)
        }
    }
}

private struct StepButtonStyle: ButtonStyle {
    init(){}
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.05 : 1.0)
            .padding(8)
            .background(BlurView())
            .background(configuration.isPressed ? Color.blue.opacity(0.5) : Color.gray.opacity(0.25))
            .shadow(radius: configuration.isPressed ? 7.5 : 0)
            .cornerRadius(6)
            .animation(.linear, value: configuration.isPressed)
    }
}
