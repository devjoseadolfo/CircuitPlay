import SwiftUI
import CircuitKit
import Combine
public struct GridView: View {
    @EnvironmentObject var envi: CircuitEnvironment
    
    private var slots: [Slot] {
        envi.circuit.circuitGrid.rows.flatMap({$0.slots})
    }
    
    private var columns: [GridItem] {
        Array(repeating: .init(.flexible(), spacing: envi.currentState == .design ? 0 : 0), count: envi.circuit.columns)
    }
    
    public init() {}
    
    public var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: false) {
                ZStack{
                    Group {
                        if envi.circuit.rows <= 10 {
                            AddButton(to: .down)
                                .offset(y: CGFloat(64 * envi.circuit.rows) + 24)
                            AddButton(to: .up)
                                .offset(y: CGFloat(-64 * envi.circuit.rows) - 24)
                        }
                        if envi.circuit.columns <= 10 {
                            AddButton(to: .right)
                                .offset(x: CGFloat(64 * envi.circuit.columns) + 24)
                            AddButton(to: .left)
                                .offset(x: CGFloat(-64 * envi.circuit.columns) - 24)
                        }
                    }
                    .opacity(envi.currentState == .design ? 1 : 0)
                    .allowsHitTesting(envi.currentState == .design)
                    GridLines(columns: envi.circuit.columns, rows:  envi.circuit.rows)
                        .stroke(Color.secondary,lineWidth: 1.5)
                        .opacity(envi.currentState == .setup ? 1 : 0)
                        .blur(radius: envi.currentState == .setup ? 0 : 1)
                        .frame(width: CGFloat(envi.circuit.columns) * 128, height: CGFloat(envi.circuit.rows) * 128)
                        .background(
                            GeometryReader { geo in
                                var point = geo.frame(in: .global).origin
                                Color.clear.preference(key: GridOriginKey.self,
                                                       value: CGPoint(x: round(point.x),y: round(point.y)))
                                    .onAppear{envi.gridOrigin = geo.frame(in: .global).origin}
                            }
                        )
                    
                    LazyVGrid(columns: columns, spacing: envi.currentState == .design ? 16 : 0) {
                        ForEach(slots) { slot in
                            GridSlotView(slot: $envi.circuit.circuitGrid.rows[slot.gridIndex.y].slots[slot.gridIndex.x])
                                .frame(width: envi.currentState == .design ? 112 : 128, height: envi.currentState == .design ? 112 : 128, alignment: .center)
                                .simultaneousGesture(envi.currentState == .design ? drag : nil)
                                .allowsHitTesting(envi.dragPosition == nil)
                                .zIndex(Double(slot.zIndex))
                        }
                    }
                }
                .animation(.easeOut)
                .padding(128)
        }
        .frame(width: .infinity, height: .infinity, alignment: .center)
        .background(Color(UIColor.secondarySystemBackground))
        .onPreferenceChange(GridOriginKey.self) {value in
            DispatchQueue.main.async {
                envi.detector.send(value)
            }
        }
        .onReceive(envi.publisher, perform: { envi.gridOrigin = $0})
    }
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 1, coordinateSpace: .global)
            .onChanged { value in
                    envi.firstDragIndex = envi.pointToGridIndex(point: value.startLocation, in: envi.gridRect)
                    envi.selectedSlot = nil
                    envi.dragPosition = envi.popoverShown ? nil : value.location
                
            }
            .onEnded { finalValue in
                let finalDragIndex = envi.pointToGridIndex(point: finalValue.location, in: envi.gridRect)
                envi.dragPosition = nil
                guard let firstIndex = envi.firstDragIndex else { return }
                envi.firstDragIndex = nil
                guard let finalIndex = finalDragIndex else { return }
                let firstComp = envi.circuit.circuitGrid[firstIndex].component
                envi.circuit.circuitGrid[firstIndex].changeComponent(to: BlankSpace())
                envi.circuit.circuitGrid[finalIndex].changeComponent(to: firstComp)
            }
    }
    
    struct GridOriginKey: PreferenceKey {
        typealias Value = CGPoint
        static var defaultValue = CGPoint.zero
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value.x += nextValue().x
            value.y += nextValue().y
        }
    }
}

extension View {
    func execute(_ closure: () -> Void) -> Self {
        closure()
        return self
    }
}


