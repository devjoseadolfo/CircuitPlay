/*:
# Series Circuits
 This page features a simple series circuit with a voltage source and two resistors. In a series circuit, the equivalent resistance of the circuit is equal to the sum of the resistance of each resistor in series.

![Equation for the Equivalent Resistance in Series Circuits](Series.PNG)
 
**Task:** Choo! Choo!
 1. Tap `Run My Code` button on the right.
 2. Tap on the `Solve` button. What are the voltages across each resistor? Do they have the same values?
 3. Try changing the value of each resistor. What happens to the voltages and current?
 4. Add another resistor to the circuits in series. Observe how it affects the voltage.
 5. Swap the voltage source for a current source. Does current differ across each resistor?


 The voltage across each resistor in series is different because according to Kirchoff’s Voltage Law, the sum of voltage rise is equal to the sum of voltage drop. In our original example, The voltage source causes a voltage rise of `5.00V` and each resistor each drops the voltage by `2.50V`. The voltage rise is equal to the sum of the two voltage drops.
 
 ![Kirchoff's Voltage Law Equation](KVL.PNG)
 
Go to the [Next Page](@next) where you will learn about resistors in parallel.
*/
import SwiftUI
import PlaygroundSupport

let preset: CircuitPreset = .series
PlaygroundPage.current.wantsFullScreenLiveView = true
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.setLiveView(
    MainView()
        .environmentObject(CircuitEnvironment(circuit: preset.circuit))
        .ignoresSafeArea()
)


