/*:
# Ohm's Law
This page features a simple circuit with two components: a voltage source and a resistor, which will show how the relationship of the voltage to the resistance and current. This relationship is described by the Ohm’s Law, which states that the voltage equal to the product of the resistance and current.

![Ohm's Law Equation](OhmsLaw.PNG)
 
**Task:** Ohm My Law!
 1. Tap `Run My Code` button on the right.
 2. Click on the `Solve` button. Feel free to tap on any of the components to check the values they hold. Components like the voltage source and resistor will show their voltage, current, and power values while wires will show their voltage in respect to the ground. The arrows indicate the current direction while the positive and negative signs indicate where the higher and lower voltages are.
 3. With a `5.00V` voltage source and `10.00Ω` resistor, the current across the voltage source is 500mA. You may change values of each components with the Setup button and tapping on the value you want to change.
 4. What happens when we increase the resistance value of the resistor? What happens to the current? What happens when we increase the value of the voltage?
 5. Click on the `Design` button and replace the voltage source with a current source and solve for the circuit? What is the current across the resistor? What about voltages of the components?
 6. On the `Setup` button, you may also view your circuits in augmented reality. In this mode, you may also tap on each model to view their values.

 
Go to the [Next Page](@next) where you will learn about resistors in series.
*/
import SwiftUI
import PlaygroundSupport

let preset: CircuitPreset = .ohmsLaw
PlaygroundPage.current.wantsFullScreenLiveView = true
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.setLiveView(
    MainView()
        .environmentObject(CircuitEnvironment(circuit: preset.circuit))
        .ignoresSafeArea()
)
