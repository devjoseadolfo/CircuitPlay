import SwiftUI
import RealityKit
import ARKit
import CircuitKit
import CircuitNetwork
import FocusEntity
import CircuitReality

protocol CircuitDelegate {
    func slotTapped(location: Location)
}

public struct ARViewContainer: UIViewRepresentable, CircuitDelegate {
    @EnvironmentObject var envi: CircuitEnvironment
    public init(){}
    public func makeUIView(context: Context) -> CircuitARView {
        let arView = CircuitARView(frame: .zero, delegate: self, network: envi.network!)
        arView.focusEntity?.isEnabled = true
        arView.contentScaleFactor = 1
        return arView
    }
    public func updateUIView(_ uiView: CircuitARView, context: Context) {
    }
    func slotTapped(location: Location) {
        envi.selectedSlot = location
    }
}

public class CircuitARView: ARView {
    var focusEntity: FocusEntity?
    var delegate: CircuitDelegate?
    var network: CircuitNetwork?
    var objectPlaced = false
    
    required init(frame frameRect: CGRect, delegate: CircuitDelegate, network: CircuitNetwork) {
        super.init(frame: frameRect)
        focusEntity = FocusEntity(on: self, focus: .classic)
        self.network = network
        self.cameraMode = .ar
        self.delegate = delegate
        self.renderOptions = [.disableFaceOcclusions, .disablePersonOcclusion, .disableHDR]
        configure()
        enablePlacement()
    }
    
    @objc override required dynamic init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        config.environmentTexturing = .automatic
        config.wantsHDREnvironmentTextures = false
        session.run(config)
    }
    func enablePlacement() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        if !objectPlaced {
            do {
                let reality = CircuitReality(network: network!)
                let circuit = reality.makeAnchorEntityForNetwork(position: focusEntity?.position ?? .zero)
                self.scene.addAnchor(circuit)
                objectPlaced = true
                focusEntity?.isEnabled = false
            } catch {
                print("No model")
            }
        } else {
            let location = recognizer.location(in: self)
            let hitTests = hitTest(location, query: .nearest)
            for hit in hitTests {
                if let locStr = hit.entity.parent?.name.components(separatedBy: ","), let x = Int(locStr[0]), let y = Int(locStr[1]) {
                    delegate?.slotTapped(location: (x, y))
                }
                if let locStr = hit.entity.parent?.parent?.name.components(separatedBy: ","), let x = Int(locStr[0]), let y = Int(locStr[1]) {
                    delegate?.slotTapped(location: (x, y))
                }
                if let locStr = hit.entity.parent?.parent?.parent?.name.components(separatedBy: ","), let x = Int(locStr[0]), let y = Int(locStr[1]) {
                    delegate?.slotTapped(location: (x, y))
                }
                if let locStr = hit.entity.parent?.parent?.parent?.parent?.name.components(separatedBy: ","), let x = Int(locStr[0]), let y = Int(locStr[1]) {
                    delegate?.slotTapped(location: (x, y))
                }
            }
        }
    }
}

