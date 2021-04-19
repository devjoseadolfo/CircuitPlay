import Combine
import Foundation
import CoreGraphics

public struct Slot: CustomStringConvertible, Identifiable {
    public var component: CircuitComponent
    public let id = UUID()
    
    public var zIndex: Int = 0
    public var gridIndex: Location = (x: 0, y: 0)
    public var selected: Bool = false
    
    public var assocNode: Int?
    public var assocModel: String?
    public var assocBranch: Int?
    
    public var description: String { component.description }
    
    public init(component: CircuitComponent) {
        self.component = component
    }
    
    public mutating func changeComponent(to newComponent: CircuitComponent){
        self.component = newComponent
    }
}

public struct Row: Identifiable {
    public let id = UUID()
    public var slots: [Slot]
    
    public init(_ slots: Slot...) {
        self.slots = slots
    }
    
    public init(_ slots: [Slot]) {
        self.slots = slots
    }
    
    public mutating func append(_ slot: Slot) {
        slots.append(slot)
    }
}

public struct Grid {
    public var rows: [Row]
    
    public init(_ rows: Row...) {
        self.rows = rows
    }
    
    public init(_ rows: [Row]) {
        self.rows = rows
    }
    
    public mutating func append(_ row: Row) {
        rows.append(row)
    }
    
    public subscript(index: Location) -> Slot {
        get {
            return rows[index.y].slots[index.x]
        }
        set {
            rows[index.y].slots[index.x] = newValue
        }
    }
}

