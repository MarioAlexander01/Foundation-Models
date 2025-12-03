//
//  ContentView.swift
//  FoundationModels2
//
//  Created by Mario Alexander on 03/12/2025.
//

import SwiftUI
import FoundationModels

struct ContentView: View {
    var body: some View {
        let session = LanguageModelSession()
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
