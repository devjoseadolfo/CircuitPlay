import SwiftUI
import CircuitKit
import CircuitNetwork

public struct InfoView: View {
    @EnvironmentObject var envi: CircuitEnvironment
    private var model: Model? {
        guard let network = envi.network, let loc = envi.selectedSlot else { return nil }
        guard let index = envi.getModelIndexAt(location: loc) else { return nil }
        return network.models[index]
    }
    
    private var node: Node? {
        guard let network = envi.network, let loc = envi.selectedSlot else { return nil }
        guard let index = envi.getNodeIndexAt(location: loc) else { return nil }
        return network.nodes[index]
    }
    
    private var show: Bool { node != nil || model != nil}
    
    public var body: some View {
        Group {
            if show {
                if let node = node {
                    NodeInfoView(node: node)
                        .transition(.opacity)
                } else if let model = model {
                    ModelInfoView(model: model)
                        .transition(.opacity)
                }
            }
        }.animation(.linear, value: show)
    }
}

private struct NodeInfoView: View {
    @EnvironmentObject var envi: CircuitEnvironment
    var node: Node
    var name: String { node.description }
    var voltage: Volts { Volts(node.voltage) }
    public init(node: Node) {
        self.node = node
    }
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .custom) {
                HStack{
                    Text("Node")
                        .font(.caption)
                    Text(name)
                        .font(.system(size: 32, weight: .heavy, design: .monospaced))
                        .alignmentGuide(.custom) { $0[.leading] }
                }
                HStack{
                    Text("Voltage")
                        .font(.caption)
                    Text(voltage.description)
                        .font(.system(size: 16, weight: .regular, design: .monospaced))
                        .alignmentGuide(.custom) { $0[.leading] }
                }
                
            }
            .padding(16)
            .background(BlurView())
            .background(Color.gray.opacity(0.25))
            .cornerRadius(16)
            .position(x: geo.frame(in: .local).maxX - 120, y: geo.frame(in: .local).midY)
        }
    }
}

private struct ModelInfoView: View {
    var model: Model
    var name: String { model.description }
    var voltage: Volts { Volts(model.voltage) }
    var current: Amperes { Amperes(model.current) }
    var power: Watts { Watts(model.power) }
    
    public init(model: Model) {
        self.model = model
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .custom) {
                HStack{
                    Text("Component")
                        .font(.caption)
                    Text(name)
                        .font(.system(size: 32, weight: .heavy, design: .monospaced))
                        .alignmentGuide(.custom) { $0[.leading] }
                }
                HStack{
                    Text("Voltage")
                        .font(.caption)
                    Text(voltage.description)
                        .font(.system(size: 16, weight: .regular, design: .monospaced))
                        .alignmentGuide(.custom) { $0[.leading] }
                }
                HStack{
                    Text("Current")
                        .font(.caption)
                    Text(current.description)
                        .font(.system(size: 16, weight: .regular, design: .monospaced))
                        .alignmentGuide(.custom) { $0[.leading] }
                }
                HStack{
                    Text("Power")
                        .font(.caption)
                    Text(power.description)
                        .font(.system(size: 16, weight: .regular, design: .monospaced))
                        .alignmentGuide(.custom) { $0[.leading] }
                }
            }
            .padding(16)
            .background(BlurView())
            .background(Color.gray.opacity(0.25))
            .cornerRadius(16)
            .position(x: geo.frame(in: .local).maxX - 120, y: geo.frame(in: .local).midY)
        }
    }
}

struct CustomAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        return context[.leading]
    }
}

extension HorizontalAlignment {
    static let custom: HorizontalAlignment = HorizontalAlignment(CustomAlignment.self)
}

