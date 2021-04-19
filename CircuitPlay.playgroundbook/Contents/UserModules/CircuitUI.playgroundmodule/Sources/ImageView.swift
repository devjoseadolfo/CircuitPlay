import SwiftUI

public struct SquareImageView: View {
    private var imageName: String
    
    public init(_ imageName: String) {
        self.imageName = imageName
    }
    
    public var body: some View {
        Image(uiImage: UIImage(named: imageName + ".PNG")!)
            .resizable()
            .aspectRatio(1, contentMode: .fit)
    }
}

