//
//  RootView.swift
//  Hidden Fee App
//
//  App entry point — hosts the Home, History, Glossary, and Contact tabs.
//

import SwiftUI

struct RootView: View {
    @State private var scanHistory = ScanHistory()
    @State private var voiceReader = VoiceReaderService()
    @AppStorage("textSizeIndex") private var textSizeIndex: Double = 2.0

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
        .environment(voiceReader)
        .dynamicTypeSize(typeSize(for: textSizeIndex))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .tint(.white)
        .preferredColorScheme(.dark)
        .onAppear {
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
