import SwiftUI
import CircuitKit

public struct AddButton: View {
    @EnvironmentObject var envi: CircuitEnvironment
    private var direction: Direction
    
    public init(to direction: Direction) {
        self.direction = direction
    }
    
    public var body: some View {
        Button {
            envi.selectedSlot = nil
            envi.circuit.shiftGrid(going: direction.opposite)
        } label: {
            Label("Add",
                  systemImage: "plus")
                .labelStyle(IconOnlyLabelStyle())
                .imageScale(.large)
                .font(Font.body.weight(.bold))
        }
        .foregroundColor(Color.secondary)
        .buttonStyle(ChevronButtonStyle())
    }
}

