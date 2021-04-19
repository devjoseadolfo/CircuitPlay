/*:
# Parallel Circuits
 This page features a parallel circuit with a voltage source and two resistors. In a parallel circuit, the equivalent resistance of the circuit is equal to the inverse of the sum of the inverse of the resistance of each resistor in parallel.

![Equation for the Equivalent Resistance in Parallel Circuits](Parallel.PNG)
 
**Task:** Parallel Parking
 1. Tap `Run My Code` button on the right.
 2. Tap on the `Solve` button. What are the voltages across each resistor? Do they have the same values?
 3. Try changing the value of each resistor. What happens to the voltages and current?
 4. Add another resistor to the circuits in parallel. Observe how it affects the current.
 5. What happens when we swap the voltage source for a current source?

 The current across each resistor in parallel is different because according to Kirchoff’s Current Law states that the sum of the current going into a node is equal to the sum of the current going out a node. In the original example, the voltage source pushes `1.00A` of current while the resistor pulls `500.00mA` of current each.
 
 ![Kirchoff's Current Law Equation](KCL.PNG)
 
Go to the [Next Page](@next) where you will learn about capacitors.
*/
import SwiftUI
import PlaygroundSupport

let preset: CircuitPreset = .parallel
PlaygroundPage.current.wantsFullScreenLiveView = true
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.setLiveView(
    MainView()
        .environmentObject(CircuitEnvironment(circuit: preset.circuit))
        .ignoresSafeArea()
)
