import Combine
import SwiftUI
import CircuitKit
import CircuitNetwork
import RealityKit
import ARKit

public class CircuitEnvironment: ObservableObject {
    @Published public var circuit: Circuit
    
    @Published public var network: CircuitNetwork?
    
    @Published public var arMode: Bool = false
    
    public init(circuit: Circuit){
        self.circuit = circuit
        let detector = CurrentValueSubject<CGPoint, Never>(.zero)
        self.publisher = detector
            .debounce(for: .seconds(1/60), scheduler: DispatchQueue.main)
            .dropFirst()
            .eraseToAnyPublisher()
        self.detector = detector
    }
    
    public func solveCircuit() {
        network = CircuitNetwork(circuit: circuit)
        network?.solveNetwork()
        currentState = .play
    }
    
    @Published var currentState: ViewState = .design {
        didSet {
            selectedSlot = nil
        }
    }
    
    let timer: Publishers.Autoconnect<Timer.TimerPublisher> = Timer.publish(every: 1 / 60, on: .main, in: .common).autoconnect()
    
    let detector: CurrentValueSubject<CGPoint, Never>
    let publisher: AnyPublisher<CGPoint, Never>
    
    @Published public var selectedSlot: Location? {
        willSet {
            guard let selectedSlot = selectedSlot else { return }
            circuit.circuitGrid[(selectedSlot)].selected = false
        }
    }
     
    @Published var popoverShown: Bool = false
    
    @Published var dragPosition: CGPoint?
    
    @Published var firstDragIndex: Location?
    
    var dragState: DragState? {
        switch (dragPosition, dragGridIndex) {
        case (nil, _):
            return nil
        case (_, nil):
             return .unknown
        default:
            return .valid
        }
    }
    
    @Published var gridOrigin: CGPoint = CGPoint.zero {
        didSet {
            DispatchQueue.main.async { [self] in
                    dragPosition = nil
                }
        }
    }
    
    
    var gridRect: CGRect {
        let gridSize = CGSize(width: circuit.columns * 128, height: circuit.rows * 128)
        return CGRect(origin: gridOrigin, size: gridSize)
    }
    
    var dragGridIndex: Location? {
        guard let dragPoint = dragPosition,
              gridRect.contains(dragPoint) else { return nil }
        return pointToGridIndex(point: dragPoint, in: gridRect)
    }
    
    public func pointToGridIndex(point: CGPoint, in rect: CGRect) -> Location? {
        let xDiff = point.x - rect.origin.x
        let yDiff = point.y - rect.origin.y
        
        let x: Int = Int(floor(xDiff / 128))
        let y: Int = Int(floor(yDiff / 128))
        
        guard x >= 0, y >= 0 else { return nil }
        
        guard x < circuit.columns, y < circuit.rows else { return nil }
        
        return (x, y)
    }
    
    @Published var draggedDock: CircuitComponent?
    
    @Published var dockOrigin: CGFloat = CGFloat.zero {
        didSet {
            DispatchQueue.main.async { [self] in
                dragPosition = nil
            }
        }
    }
    
    func getModelIndexAt(location: Location) -> Int? {
        guard let network = network else { return nil }
        let modelSlot = network.circuit.circuitGrid[location]
        guard let model = modelSlot.assocModel else { return nil }
        return network.models.firstIndex { $0.description == model}
    }
    
    func getNodeIndexAt(location: Location) -> Int? {
        guard let network = network else { return nil }
        let nodeSlot = network.circuit.circuitGrid[location]
        guard let node = nodeSlot.assocNode else { return nil }
        return node
    }
}



