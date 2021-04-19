import CircuitKit
import Foundation

public struct Node: CustomStringConvertible, Identifiable {
    public var number: Int
    public var description: String { "N" + String(number) }
    
    public var connectedNodes: [String : Int] = [:]
    public var connectedBranches: [Int] = []
    public var connectedModels: [String] = []
    
    public var openings: [(Location, Direction)] = []
    public var locations: [Location] = []
    
    public var voltage: Double = 0
    
    public var id = UUID()
    
    public init(_ number: Int) {
        self.number = number
    }
}
