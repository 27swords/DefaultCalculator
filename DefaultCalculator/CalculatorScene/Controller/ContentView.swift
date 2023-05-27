//
//  ContentView.swift
//  DefaultCalculator
//
//  Created by Alexander Chervoncev on 25/5/2023.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - Inits
    @State var value = "0"
    @State var currentOperation: Operation = .none
    @State var runningNumber = 0.0
    
    let buttons: [[CalculatorButtons]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal]
    ]
    
    //MARK: - Create CalculatorView
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(value)
                        .bold()
                        .foregroundColor(.white)
                        .font(.system(size: 100))
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding()
                
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button {
                                self.didTap(button: item)
                            } label: {
                                Text(item.rawValue)
                                    .font(.system(size: 32))
                                    .frame(width: self.buttonWidth(item: item),
                                           height: self.buttonHeight())
                                    .background(item.buttonColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(self.buttonWidth(item: item) / 2)
                            }
                        }
                    }
                    .padding(.bottom, 3)
                }
            }
        }
    }
        
    //MARK: - Methods
    ///function handles user interactions with the calculator buttons
    func didTap(button: CalculatorButtons) {
        switch button {
        case .add, .subtract, .multiply, .divide:
            currentOperation = operation(for: button)
            runningNumber = Double(value) ?? 0.0
            value = "0"
        case .equal:
            performCalculation()
            currentOperation = .none
        case .clear:
            value = "0"
        case .decimal:
            if !value.contains(".") {
                value += "."
            }
        case .percent:
            performCalculation()
            currentOperation = .none
        case .negative:
            if value.prefix(1) == "." {
                value = String(value.dropFirst())
            } else {
                value = "." + value
            }
        default:
            let number = button.rawValue
            if value == "0" {
                value = number
            } else {
                value += number
            }
        }
    }

    ///Is a helper function that takes a CalculatorButtons value as input and returns the corresponding Operation value.
    private func operation(for button: CalculatorButtons) -> Operation {
        switch button {
        case .add: return .add
        case .subtract: return .subtract
        case .multiply: return .multiply
        case .divide: return .divide
        default: return .none
        }
    }

    ///is a function that performs the calculation based on the current operation and values stored in the calculator
    private func performCalculation() {
        let runningValue = runningNumber
        let currentValue = Double(value) ?? 0.0
        var result: Double = 0.0
        switch currentOperation {
        case .add: result = runningValue + currentValue
        case .subtract: result = runningValue - currentValue
        case .multiply: result = runningValue * currentValue
        case .divide: result = runningValue / currentValue
        case .none: break
        }
        
        if currentOperation == .none && runningNumber != 0 {
            let percentageValue = currentValue / 100.0 * runningValue
            value = "\(percentageValue)"
        }
        
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            value = String(Int(result))
        } else {
            value = String(result)
        }
    }

    //MARK: - Button style
    func buttonWidth(item: CalculatorButtons) -> CGFloat {
        if item == .zero {
            return (UIScreen.main.bounds.width - (4*12)) / 4 * 2
        }
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
    
    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
}

//MARK: - ContentView_Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
