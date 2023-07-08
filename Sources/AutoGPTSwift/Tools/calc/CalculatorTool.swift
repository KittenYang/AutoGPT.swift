//
//  File.swift
//  
//
//  Created by KittenYang on 2023/7/6.
//

import Foundation

struct CalculatorTool: AutoGPTTool {
    
    static func == (lhs: CalculatorTool, rhs: CalculatorTool) -> Bool {
        return lhs.name == rhs.name &&
        lhs.description == rhs.description
    }
    
    let name: String = "calculator"
    let description: String = "Useful for getting the result of a math expression. The input to this tool should be a valid mathematical expression that could be executed by a simple calculator."
    func execute(input: String) async -> String {
        return await calculator(input)
    }
    
    init() {
    }
    
    private func calculator(_ input: String) async -> String {
        // Implement calculator functionality here
        // TODO: You can use Expression library or any other math library to evaluate the expression
        return "x+Y"
    }
    
    
    
}




