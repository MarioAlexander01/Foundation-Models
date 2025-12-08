//
//  TabsView.swift
//  FoundationModels2
//
//  Created by Mario Alexander on 03/12/2025.
//

import SwiftUI

enum TabsMenu: String, CaseIterable, View {
    case home = "Home"
    case profile = "Profile"
    
    var id: Self { self }
    var body: some View {
        switch self {
        case .home:
            HomeView()
        case .profile:
            Text("2")
        }
    }
    
    var logo: String {
        switch self {
        case .home:
            "fork.knife.circle"
        case .profile:
            "map.circle"
        }
    }
}


struct TabsView: View {
    @Environment(NavigationManger.self) var navManager
    var body: some View {
        @Bindable var navManager = navManager
        TabView(selection: $navManager.selectedTab) {
                ForEach(TabsMenu.allCases.indices, id: \.self) { index in
                    let tab = TabsMenu.allCases[index]
                    Tab(
                        tab.rawValue,
                        systemImage: tab.logo,
                        value: tab) {
                            tab
                        }
                }
        }
        .tint(.indigo)
        .tabBarMinimizeBehavior(.automatic)
    }
}

#Preview {
    TabsView()
        .environment(NavigationManger())
}
