//
//  ContactView.swift
//  Hidden Fee App
//
//  Created by Apple on 7/20/26.
//

import SwiftUI

struct ContactView: View {
    @State private var showingSettings = false
    @Environment(VoiceReaderService.self) private var voiceReader

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    ContactRow(
                        icon: "envelope.fill",
                        title: "Email Support",
                        subtitle: "support@hiddenfeeapp.com",
                        tint: .blue
                    ) {
                        if let url = URL(string: "mailto:support@hiddenfeeapp.com") {
                            UIApplication.shared.open(url)
                        }
                    }

                    ContactRow(
                        icon: "exclamationmark.bubble.fill",
                        title: "Report an Issue",
                        subtitle: "Flag an incorrect or missed finding",
                        tint: .orange
                    ) {
                        if let url = URL(string: "mailto:support@hiddenfeeapp.com?subject=Issue%20Report") {
                            UIApplication.shared.open(url)
                        }
                    }

                    ContactRow(
                        icon: "star.fill",
                        title: "Rate the App",
                        subtitle: "Let others know if this helped you",
                        tint: .yellow
                    ) {
                        // Replace with App Store review URL once published.
                    }

                    HStack(spacing: 12) {
                        Image(systemName: "lock.shield.fill")
                            .font(.title3)
                            .foregroundStyle(.green)
                            .frame(width: 42, height: 42)
                            .background(Color.green.opacity(0.12), in: RoundedRectangle(cornerRadius: 11))
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Your data stays on-device")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.white)
                            Text("Documents are never uploaded or shared without your permission.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.green.opacity(0.07), in: RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.green.opacity(0.2), lineWidth: 1))
                    .padding(.top, 8)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Get in Touch")
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.white)
                    }
                }
            }
            .onAppear {
                voiceReader.speak("Contact screen. Options to email support, report an issue, or rate the app.")
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}

private struct ContactRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(tint)
                    .frame(width: 44, height: 44)
                    .background(tint.opacity(0.15), in: RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(14)
            .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContactView()
        .environment(VoiceReaderService())
}
