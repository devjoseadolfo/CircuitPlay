import SwiftUI
import CircuitKit

public struct MeasurementEditView: View {
    @EnvironmentObject var envi: CircuitEnvironment
    @Binding private var measurement: CircuitUnit
    @Binding private var show: Bool
    @State private var value: Double = 0
    @State private var multiplier: Double = 1
    @State private var field = ""
    @State private var isNegative: Bool = false
    
    private var unitPrefix: UnitPrefix {
        return getPrefix(value: multiplier)
    }
    private var baseUnit: BaseUnit = .watt
    
    private var fieldLimit: Int = 3
    
    public init(measurement: Binding<CircuitUnit>, show: Binding<Bool>) {
        self._measurement = measurement
        self._show = show
        self.value = measurement.wrappedValue.value
        self.baseUnit = measurement.wrappedValue.base
        multiplier = pow(10, Double(measurement.wrappedValue.unitPrefix.rawValue))
        self.multiplier = multiplier.isZero ? 1 : multiplier
    }
    
    var display: String {
        let sign = isNegative ? "-" :  "+"
        return sign + field + " " + unitPrefix.symbol + baseUnit.symbol
    }
    
    public var body: some View {
        HStack{
            VStack(spacing: 4) {
                Text(display)
                    .font(.system(size: 13.5, weight: .regular, design: .monospaced))
                    .multilineTextAlignment(.leading)
                    .frame(width: 102, height: 32)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray.opacity(0.25), lineWidth: 2)
                                .frame(width: 102))
                numPad
            }
            unitPicker
        }.padding(10)
    }
    
    private var columns: [GridItem] {
        Array(repeating: .init(.fixed(32), spacing: 4), count: 3)
    }
    
    var numPad: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(NumPadButton.allCases, id: \.self) { number in
                Button {
                    switch number {
                    case .plusminus:
                        isNegative.toggle()
                    default:
                        field.append(number.rawValue)
                    }
                } label: {
                    Label(number.rawValue, systemImage: number.sfSymbol)
                        .labelStyle(IconOnlyLabelStyle())
                        .font(.system(size: 24, weight: .regular))
                        .imageScale(.small)
                        .scaleEffect(number == .decimal ? 0.25 : 1)
                }
                .buttonStyle(PadButtonStyle(color: Color.gray))
                .opacity(getBool(for: number, in: field) ? 1 : 0.25)
                .allowsHitTesting(getBool(for: number, in: field))
            }
        }
    }
    
    func getBool(for button: NumPadButton, in field: String) -> Bool{
        switch button {
        case .plusminus:
            return !(measurement is Ohms || measurement is Farads || measurement is Henries || measurement is Hertz)
        case .decimal:
            return field.count > 0 && field.count <= fieldLimit && !field.contains(".")
        default:
            return field.count <= fieldLimit && (!field.hasSuffix("0") || field.count > 1)
        }
    }
    
    
    var unitPicker: some View {
        VStack(spacing: 4){
            Button {
                let sign: Double = isNegative ? -1 : 1
                let finalValue = (Double(field) ?? 0) * multiplier * sign
                measurement = measurement.base.createUnit(from: finalValue)
                show = false
            }
            label: {
                Label("Done", systemImage: "checkmark")
                    .font(Font.body.bold())
                    .labelStyle(IconOnlyLabelStyle())
                    .foregroundColor(Color.green)
            }
                .buttonStyle(PadButtonStyle(color: Color.green))
                .opacity(field.count > 0 && !field.hasSuffix(".") ? 1 : 0.25)
                .allowsHitTesting(field.count > 0 && !field.hasSuffix("."))
            Button { multiplier *= 1000 }
            label: {
                Label("Increase", systemImage: "chevron.up")
                    .font(Font.body.bold())
                    .labelStyle(IconOnlyLabelStyle())
            }
                .buttonStyle(PadButtonStyle(color: Color.blue))
                .opacity(unitPrefix != .giga ? 1 : 0.25)
                .allowsHitTesting(unitPrefix != .giga)
            Text(unitPrefix.symbol + baseUnit.symbol)
                .font(.system(size: 13.5, weight: .regular, design: .monospaced))
                .frame( height: 32)
                .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray.opacity(0.25), lineWidth: 2)
                            .frame(width: 31))
            Button { multiplier *= 0.001 }
                label: {
                    Label("Decrease", systemImage: "chevron.down")
                        .font(Font.body.bold())
                        .labelStyle(IconOnlyLabelStyle())
                }
                .buttonStyle(PadButtonStyle(color: Color.blue))
                .opacity(unitPrefix != .nano ? 1 : 0.25)
                .allowsHitTesting(unitPrefix != .nano)
            Button { field = "" }
                label: {
                    Label("Clear", systemImage: "c.circle")
                        .font(Font.body.bold())
                        .foregroundColor(Color.red)
                        .labelStyle(IconOnlyLabelStyle())
                }
                .opacity(!field.isEmpty ? 1 : 0.25)
                .allowsHitTesting(!field.isEmpty)
                .buttonStyle(PadButtonStyle(color: Color.red))
        }
    }
}

enum NumPadButton: String, CaseIterable, Identifiable{
    case one = "1", two = "2", three = "3"
    case four = "4" , five = "5" , six = "6"
    case seven = "7", eight = "8", nine = "9"
    case decimal = ".", zero = "0", plusminus
    
    var sfSymbol: String {
        switch self {
        case .decimal:
            return "circlebadge.fill"
        case .plusminus:
            return "plusminus"
        default:
            return self.rawValue + ".circle"
        }
    }
    
    var id: String { self.rawValue }
    }

public struct PadButtonStyle: ButtonStyle {
    var color: Color
    public init(color: Color){
        self.color = color
    }
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.25 : 1.0)
            .frame(width: 24, height: 24, alignment: .center)
            .aspectRatio(1.0, contentMode: .fit)
            .padding(4)
            .background(configuration.isPressed ? color.opacity(0.25) : Color.gray.opacity(0.125))
            .cornerRadius(4)
            .shadow(radius: configuration.isPressed ? 7.5 : 0)
            .animation(.linear(duration: 0.25), value: configuration.isPressed)
    }
}

