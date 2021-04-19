/*:
# Sandbox
 In this page, you will be free to create your own circuit!
 
 Here are some rules to remember when making a circuit:
 - Make sure there are no loose ends. Each terminal of a component should be connected to another terminal of a different component.
 - Each loop in a circuit should at least have one resistor. Otherwise, you would be createing an invalid circuit with a short.
 - Don't forget to add the ground. The ground serves a reference nodes so the simulator can determine the voltages of each node.
 - When using a capacitor or an inductor, always include a resistor in the loop as well. Without a resistor, the current or voltage across a capacitor or inductor will be an impulse, causing the values to be discontinuous.
 
 Have fun!
*/
import SwiftUI
import PlaygroundSupport

let preset: CircuitPreset = .blank
PlaygroundPage.current.wantsFullScreenLiveView = true
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.setLiveView(
    MainView()
        .environmentObject(CircuitEnvironment(circuit: preset.circuit))
        .ignoresSafeArea()
)
