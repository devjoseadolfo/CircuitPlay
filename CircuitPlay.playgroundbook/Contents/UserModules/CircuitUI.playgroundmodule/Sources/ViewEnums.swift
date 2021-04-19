import SwiftUI

public enum ViewState: CaseIterable, Identifiable {
    case design
    case setup
    case play
    
    public var id: Int {
        self.hashValue
    }
}

public enum DragState {
    case unknown
    case valid
}

public enum ViewColor {
    case slotBackground
    
    var color: Color {
        switch self {
        case .slotBackground:
            return Color(UIColor.secondaryLabel)
        }
    }
}

extension Color {
    public func getBackground(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return Color(white: 0.5)
        case .dark:
            return Color(white: 0.65)
        }
    }
}
