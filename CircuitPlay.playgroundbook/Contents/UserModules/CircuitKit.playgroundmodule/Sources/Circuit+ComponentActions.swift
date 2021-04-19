extension Circuit {
    public mutating func removeComponent(from location: Location) {
        circuitGrid[location] = Slot(component: BlankSpace())
    }
    
    public mutating func moveComponent(from origin: Location, to destination: Location) {
        let selectedComp = circuitGrid[origin].component
        removeComponent(from: origin)
        replaceComponent(with: selectedComp, at: destination)
    }
    
    public mutating func replaceComponent(with comp: CircuitComponent, at destination: Location) {
        circuitGrid[destination] = Slot(component: comp)
    }
}

