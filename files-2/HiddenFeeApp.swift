//
//  HiddenFeeApp.swift
//  Hidden Fee App
//
//  NOTE: You likely already have an @main App struct somewhere that isn't
//  in what's been shared so far. Merge this into that file rather than
//  adding a second @main — Xcode will fail to build with two entry points.
//  The two things that matter are: root view is now RootTabView (not
//  HomeView directly), and .modelContainer(for: ScanHistoryEntry.self)
//  is attached so @Query/@Environment(\.modelContext) work anywhere
//  in the tree.
//

import SwiftUI

@main
struct HiddenFeeApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
        .modelContainer(for: ScanHistoryEntry.self)
    }
}
