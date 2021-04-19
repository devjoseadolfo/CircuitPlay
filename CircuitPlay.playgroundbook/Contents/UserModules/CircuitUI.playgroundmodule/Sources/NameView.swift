import SwiftUI
import CircuitKit

public struct NameView: View {
    private var name: String
    public init(name: String) {
        self.name = name
    }
    
    public var body: some View {
        Text(name)
            .font(.system(size: 13.5, weight: .regular, design: .monospaced))
            .foregroundColor(Color.primary)
            .frame(height: 20, alignment: .center)
            .padding(.horizontal, 4)
            .background(Color.gray.opacity(0.25))
            .background(BlurView())
            .background(Color.white.opacity(0))
            .cornerRadius(4)
    }
    
}

