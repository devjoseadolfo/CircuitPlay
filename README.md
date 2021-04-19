# CircuitPlay

## Introduction
Hello, welcome to my submission for WWDC21 Swift Student Challenge, CircuitPlay! CircuitPlay is an interactive sandbox experience that allows you to design, setup, and simulate circuit. CircuitPlay is written in Swift and built with SwiftUI, Accelerate, ARKit, and RealityKit. The showcase video can be found [here](https://youtu.be/pm3mlDZJSes).

      
## User Interface
Existing circuit simulators on the market today have cluttered and outdated user interface. For students who are new to circuit theory, they may find these simulators daunting and overwhelming. CircuitPlay aims to fill the need for a simple and intuitive circuit simulator. CircuitPlay is a program with touch interface in mind. The fluidity of its user interface is thanks to versatility that SwiftUI provides. 

CircuitPlay has three stages: Design, Setup, and Solve. In the Design stage, the user is presented with a grid and dock. The user can pick any component from the dock and drop it to a slot in the grid. Tapping a slot will show controls to rotate or delete the component. The Setup stage allows the user to change a component’s value by showing a popover prompt when the measurement is tapped.

## Circuit-Solving Algrithm
In the Solve stage, CircuitPlay uses its circuit solving algorithm. CircuitPlay first determines the nodes present in the circuit through recursion and matches the appropriate model for each circuit component. These nodes and models are the make up the circuit network.

Afterwards, CircuitPlay uses the modified nodal analysis (MNA) stamping method, where the A matrix and b vector are formed. The A matrix describes the conductance between each node and the connections of voltage sources and each node. The b vector includes the known values, which are the current across nodes and the voltage sources values. Solving the x vector in Ax = b will provide node voltages and current across voltage sources. 

The A matrix is sparse, meaning, there are zeroes that are present in the matrix. To leverage this, CircuitPlay utilizes Accelerate’s Sparse Solver framework to factor and solve the matrix, as opposed to LAPACK which requires matrices to be dense. The matrix generated by CircuitPlay is also always symmetric, thus, storing only the upper triangle of the sparse matrix saves in memory. Since the matrix is symmetric and since the matrix is always positive-indefinite, the appropriate factorization method used is the LDLᵀ decomposition. A direct method is utilized, meaing the matrix is only factored and solved once. Since there are no nonlinear components, like diodes and transistors, it removes the need for an iterative method as there is no need to determine convergence with an I-V curve.

Using the SparseSolve methods, the node voltages and voltage source currents are solved. Using Kirchoff’s Current Law and Ohm’s Law, the voltage and current across the different components are determined. For time-domain components like capacitors and inductors, a linearized companion model are utilized and backwards Euler’s method is performed to determine the equivalent values of the companion model at time step n+1. 

## Augmented Reality
CircuitPlay also provides an option to view the circuit in augmented reality. This AR portion is powered by ARKit and RealityKit. RealityKit allowed CircuitPlay to display 3D models with such high performance. I also used Focus Entity, an open-source Swift Package, to easily communicate surface detection to the user. Just like my WWDC2020 submission LearnWithAR, CircuitPlay also proves that augmented reality will have important role in the STEM education space in the future.

## Credits    

 - [Barlow font](https://github.com/jpt/barlow) designed by Jeremy Tribby found in the Playground thumbnail and the images in each PlaygroundPage is used under the [Open Font License](https://github.com/jpt/barlow/blob/main/OFL.txt).
 - San Francisco font found in the Playground’s interface is accessed as part of iPadOS’ system fonts and used fairly within the license set by Apple Inc. for the development of software for Apple platforms.
 - [Focus Entity](https://github.com/maxxfrazer/FocusEntity) Swift Package by Max Cobb is used in the augmented reality component of the Playground for placing the model entity in the view. The package is used under the [MIT license](https://github.com/maxxfrazer/FocusEntity/blob/main/LICENSE).

## Screenshots
