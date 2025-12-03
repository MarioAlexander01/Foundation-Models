//
//  HomeView.swift
//  FoundationModels2
//
//  Created by Mario Alexander on 03/12/2025.
//

import SwiftUI
import FoundationModels

struct HomeView: View {
    @Environment(NavigationManger.self) var navManager
    @State private var prompt = ""
    @State private var reply = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Question", text: $prompt)
                    .textFieldStyle(.roundedBorder)
                
                Button("Answer") {
                    prompt.removeAll()
                    
                    let session = LanguageModelSession()
                    Task {
                        reply = try await session.respond(to: prompt).content
                    }
                }
                .buttonStyle(.borderedProminent)
                .glassEffect()
                .disabled(prompt.isEmpty)
                
                ScrollView {
                    Text(reply)
                }
            }
            .padding()
            .navigationTitle(navManager.selectedTab.rawValue)
        }
    }
}

#Preview {
    @Previewable @State var navManager = NavigationManger()
    HomeView()
        .environment(navManager)
}
