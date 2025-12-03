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
    case setting = "Settings"
    
    var id: Self { self }
    var body: some View {
        switch self {
        case .home:
            HomeView()
        case .profile:
            Text("2")
        case .setting:
            Text("3")
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
                        systemImage: "\(index + 1).circle",
                        value: tab) {
                            tab
                        }
                }
        }
    }
}

#Preview {
    TabsView()
        .environment(NavigationManger())
}
