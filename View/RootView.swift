//
//  RootView.swift
//  Hidden Fee App
//
//  App entry point — hosts the Home, History, and Glossary tabs.
//

import SwiftUI

struct RootView: View {
    @State private var scanHistory = ScanHistory()

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "doc.text.magnifyingglass")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }

            GlossaryView()
                .tabItem {
                    Label("Glossary", systemImage: "book.closed")
                }
            
            ContactView()
                          .tabItem {
                              Label("Contact", systemImage: "envelope")
                          }
            
        }
        .environment(scanHistory)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .tint(.white)
        .preferredColorScheme(.dark)
        .onAppear {
            // Make the tab bar itself match the dark theme (opaque black,
            // not the default translucent/blur look).
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .black
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    RootView()
}
