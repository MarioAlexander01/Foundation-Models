//
//  FoundationModels2App.swift
//  FoundationModels2
//
//  Created by Mario Alexander on 03/12/2025.
//

import SwiftUI

@main
struct FoundationModels2App: App {
    @State private var navManager = NavigationManger()
    var body: some Scene {
        WindowGroup {
            TabsView()
                .environment(navManager)
        }
    }
}
