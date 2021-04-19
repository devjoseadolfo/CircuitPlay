extension Circuit {
    public mutating func shiftGrid(going direction: Direction){
        func createRepeatingBlankSlots(_ count: Int) -> [Slot] {
            var blankSlots = [Slot]()
            for _ in 0..<count {
                blankSlots.append(Slot(component: BlankSpace()))
            }
            return blankSlots
        }
        
        switch direction {
        case .up:
            self.circuitGrid.rows.append(Row(createRepeatingBlankSlots(columns)))
            rows += 1
        case .down:
            self.circuitGrid.rows.insert(Row(createRepeatingBlankSlots(columns)), at: 0)
            rows += 1
        case .left:
            for y in yRange {
                self.circuitGrid.rows[y].slots.append(Slot(component: BlankSpace()))
            }
            columns += 1
        case .right:
            for y in yRange {
                self.circuitGrid.rows[y].slots.insert(Slot(component: BlankSpace()), at: 0)
            }
            columns += 1
        }
    }
    
    public mutating func decreaseGrid(from direction: Direction){
        switch direction {
        case .up:
            self.circuitGrid.rows.removeFirst()
            rows -= 1
        case .down:
            self.circuitGrid.rows.popLast()
            rows -= 1
        case .left:
            for y in yRange {
                self.circuitGrid.rows[y].slots.removeFirst()
            }
            columns -= 1
        case .right:
            for y in yRange {
                self.circuitGrid.rows[y].slots.removeLast()
            }
            columns -= 1
        }
    }
    
    public func move(from location: Location, to direction: Direction) throws -> Location {
        var newLocation: Location {
            switch direction {
            case .up:
                return (location.x, location.y - 1)
            case .down:
                return (location.x, location.y + 1)
            case .left:
                return (location.x - 1, location.y)
            case .right:
                return (location.x + 1, location.y)
            }
        }
        
        guard newLocation.x >= 0,
              newLocation.y >= 0,
              newLocation.x < self.columns,
              newLocation.y < self.rows else {
            throw CircuitError.LocationOutOfBoundsError
        }
        
        return newLocation
    }
}

