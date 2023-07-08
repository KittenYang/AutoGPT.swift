//
//  GoogleSearchTool.swift
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

struct GoogleSearchTool: AutoGPTTool {

    static func == (lhs: GoogleSearchTool, rhs: GoogleSearchTool) -> Bool {
        return lhs.name == rhs.name &&
        lhs.description == rhs.description
    }
    
    let name: String = "search"
    let description: String = "a search engine. useful for when you need to answer questions about current events. input should be a search query."
    func execute(input: String) async -> String {
        return await googleSearch(input)
    }
    
    init() {

    }
    
    private func googleSearch(_ question: String) async -> String {
        // Implement Google search functionality here
        #error("Modify this property to reflect your SERP's API key, then comment this line out.")
        let serpApiKey = "SERP_API_KEY"
        let urlString = "https://serpapi.com/search?api_key=\(serpApiKey)&q=\(question.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
        
        let url = URL(string: urlString)!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let model = try JSONDecoder().decode(SearchResult.self, from: data)
            
//        MARK: may use below extract
            /**
             
             let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
             let answerbox = json?["answer_box"] as? [String: Any]
             let organicResults = json?["organic_results"] as? [[String: Any]]
             */
            
            let answerText = model.answerBox.answer ?? model.answerBox.snippet ?? model.organicResults.first?.snippet
            return answerText ?? ""
        } catch {
            print("SuperJSONDecoder Error: \(error)")
            return ""
        }
    }
    
}


