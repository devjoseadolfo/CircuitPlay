/*:
# Capacitance
 This page features a circuit with a resistor-capacitor circuit. A capacitor is passive circuit component and it has the ability to store electric charge using an electric field. The current across a capacitor is equal to the capacitance of the capacitor and the voltage change per unit time.

![Equation for Capacitance](Capacitance.PNG)
 
**Task:** Capacitate My Current
 1. Tap `Run My Code` button on the right.
 2. Click on the `Solve` button. What is the voltage across the capacitor?
 3. Tap on the `Next Time Step` button. This should solve the circuit values after a time step of 10 millisecond. What happens to voltage and current? Does it increase or decrease?
 4. Change the value of the capacitance? How does it affect the rate of change of the voltage and current?

 In a direct current circuit, the capacitor would have stored its full capacity after five time constants, thus, the capacitor will cause the circuit to short.

Go to the [Next Page](@next) where you will learn about inductors.
*/
import SwiftUI
import PlaygroundSupport

let preset: CircuitPreset = .resistorCapacitor
PlaygroundPage.current.wantsFullScreenLiveView = true
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.setLiveView(
    MainView()
        .environmentObject(CircuitEnvironment(circuit: preset.circuit))
        .ignoresSafeArea()
)
