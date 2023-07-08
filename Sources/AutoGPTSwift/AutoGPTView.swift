//
//  AutoGPTView.swift
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


import SwiftUI

#if DEBUG
struct AutoGPTView: View {
    
    @StateObject var autoGPT = AutoGPT(api: DemoAPI(), promptFilePath: prt, mergeFilePath: merge)

    @ViewBuilder
    private func card(_ m: String, _ s: String, color: Color = .pink) -> some View {
        VStack(alignment: .leading) {
            Text(m)
                .font(.title)
                .fontWeight(.medium)
            Text(s)
                .font(.system(size: 14.0, weight: .regular, design: .rounded))
        }
        .padding()
        .cornerRadius(6.0)
    }

    var question = "Who holds the latest third-order Rubik's Cube world record? How much time?"
    
    var body: some View {
        VStack {
            Text(question)
                .font(.system(size: 20.0, weight: .bold, design: .rounded))
                .padding()
            roll()
        }
    }
    
    @ViewBuilder func roll() -> some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(autoGPT.chunks) { chunk in
                        ZStack {
                            VStack(alignment: .leading) {
                                card("🧠 Thought", chunk.thought ?? "Empty")
                                card("🏃🏻‍♀️ Action", chunk.action ?? "Empty")
                                card("⌨️ Observation", chunk.action_input ?? "Empty")
                                card("🍎 Result", chunk.observation ?? "Empty")
                                if let final = chunk.final_answer {
                                    card("✅ Final Result", final)
                                } else {
                                    Text("Thinking...")
                                        .font(.system(size: 14.0, weight: .medium, design: .rounded))
                                        .padding()
                                }
                            }
                            .padding()
                        }
                        .transition(.move(edge: .bottom))
                        .frame(maxWidth: nil)
                        .modifier(if: chunk.final_answer != nil, then: { v in
                            v
                                .foregroundColor(.white)
                                .background(Color.green)
                        }, else: { v in
                            v
                                .background(Color.white)
                        })
                        .cornerRadius(10.0)
                        .shadow(color: .black.opacity(0.07), radius: 15.0, x: 0.0, y: -10.0)
                        .padding()
                    }
                    
                    if autoGPT.chunks.last?.final_answer == nil {
                        ProgressView()
                            .padding()
                            .id("loading")
                    }
                }
                .padding()
            }
            .onChange(of: autoGPT.chunks.count) { _ in
                scrollToBottom(scrollViewProxy: proxy)
            }
            .background(Color.gray)
            .task {
                await autoGPT.runWithInput(question)
            }
        }
    }
    
    private func scrollToBottom(scrollViewProxy: ScrollViewProxy) {
        
        guard var lastItemID = autoGPT.chunks.last?.id else { return } // assuming your data is an array of identifiable items
        if autoGPT.chunks.last?.final_answer == nil {
            lastItemID = "lallal"
        }
        withAnimation {
            scrollViewProxy.scrollTo(lastItemID, anchor: .bottom)
        }
    }
}

struct AutoGPTView_Previews: PreviewProvider {
    static var previews: some View {
        AutoGPTView()
    }
}

#endif
