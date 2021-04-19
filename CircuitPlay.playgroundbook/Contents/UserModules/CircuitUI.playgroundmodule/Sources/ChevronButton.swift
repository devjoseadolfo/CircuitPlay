import SwiftUI
import CircuitKit

public struct ChevronButton: View {
    @Binding private var show: Bool
    private var showDirection: Direction
    private var hideDirection: Direction
    
    public init(_ show: Binding<Bool>, direction: Direction) {
        self._show = show
        self.showDirection = direction
        self.hideDirection = direction.opposite
    }
    
    public var body: some View {
        Button {
            show.toggle()
        } label: {
            Label(show ? "Hide Components" : "Show Components",
                  systemImage: hideDirection.chevron)
                .labelStyle(IconOnlyLabelStyle())
                .imageScale(.large)
                .font(Font.body.weight(.bold))
                .rotationEffect(show ? .degrees(180) : .zero)
        }
        .foregroundColor(Color.secondary)
        .buttonStyle(ChevronButtonStyle())
    }
}

struct ChevronButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 32, height: 32, alignment: .center)
            .aspectRatio(1.0, contentMode: .fit)
            .padding(4)
            .background(configuration.isPressed ? Color.blue.opacity(0.5) : Color.gray.opacity(0.25))
            .background(BlurView())
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 1.5 : 1.0)
            .shadow(radius: configuration.isPressed ? 7.5 : 0)
            .animation(.linear, value: configuration.isPressed)
    }
}

