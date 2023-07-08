//
//  AutoGPT.swift
//  AutoGPTSwift
//
//  Created by Qitao Yang on 2023/5/7.
//
//  Copyright (c) 2020 KittenYang <kittenyang@icloud.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import Combine

public class AutoGPT: ObservableObject {
    private let promptTemplate: String
    private let mergeTemplate: String
    
    private var tools: [any AutoGPTTool]
    
    private var chatAPI: any ChatAPI
    
    private var toolsDict: [String: any AutoGPTTool] {
        var dict = [String: any AutoGPTTool]()
        for tool in tools {
            if dict[tool.name] == nil {
                dict[tool.name] = tool
            }
        }
        return dict
    }
    
    public func registerTool(_ tool: any AutoGPTTool) {
        tools.append(tool)
    }

    public func unRegisterTool(_ tool: any AutoGPTTool) {
        tools.removeAll(where: { $0.name == tool.name && $0.description == tool.description })
    }
    
    @Published public private(set) var chunks = [AutoGPTChunk]()
    
    public private(set) var history = ""
    
    /// MARK: init method
    public init(api: any ChatAPI, promptFilePath: String, mergeFilePath: String) {
        chatAPI = api
        promptTemplate = promptFilePath//try! String(contentsOfFile: promptFilePath, encoding: .utf8)
        mergeTemplate = mergeFilePath//try! String(contentsOfFile: mergeFilePath, encoding: .utf8)
        
        tools = [
            GoogleSearchTool(),
            CalculatorTool()
        ]
    }
    
    public func runWithInput(_ input: String?) async {
        
        print("How can I help?")
        let ques: String? = input
        guard var question = ques else {
            print("❌ Pls fill the question first")
            return
        }
        
        if !history.isEmpty {
            question = await mergeHistory(question: question, history: history)
        }

        let answer = await answerQuestion(question: question)
        print("\n🍻 The final ans:：\(answer)")
        history += "Q:\(question)\nA:\(answer)\n"
    }
    
}

// MARK: helper
extension AutoGPT {
    
    @MainActor
    func answerQuestion(question: String) async -> String {
        let dict = toolsDict
        var prompt = promptTemplate
            .replacingOccurrences(of: "${question}", with: question)
            .replacingOccurrences(of: "${tools}", with: dict.map { "\($0.key): \($0.value.description)" }.joined(separator: "\n"))
        print("🚚prompt：\(prompt)")
        var cout = 0
        
        
        while true {
            cout += 1
            let response = await completePrompt(prompt: prompt)
            prompt += response
            print("😁😁😁😁😁 No.\(cout) \n\(prompt)")
            
            let action = response.capture(pattern: "Action: (.*)")?.last?.trimmingCharacters(in: .whitespaces)
            let thought = response.capture(pattern: "Thought: (.*)")?.last
            
            var chunk = AutoGPTChunk(action: action, thought: thought)
            
            if let action = action, let actionInput = response.capture(pattern: "Action Input: \"?(.*)\"?")?.last {
                let observation: String = (await dict[action]?.execute(input: actionInput) as? String ?? "Empty")
                print("🧠🧠🧠🧠🧠 Observation：\(observation)")
                prompt += "Observation: \(observation)\n"
                chunk.action_input = actionInput
                chunk.observation = observation
                chunks.append(chunk)
            } else {
                let finalAnswer = response.capture(pattern: "Final Answer: (.*)")?.last ?? ""
                chunk.final_answer = finalAnswer
                chunks.append(chunk)
                return finalAnswer
            }
        }
    }
    
    private func mergeHistory(question: String, history: String) async -> String {
        let prompt = mergeTemplate
            .replacingOccurrences(of: "${question}", with: question)
            .replacingOccurrences(of: "${history}", with: history)
        return await completePrompt(prompt: prompt)
    }
    
    private func completePrompt(prompt: String) async -> String {
        return await chatAPI.completePrompt(prompt: prompt)
    }
}
