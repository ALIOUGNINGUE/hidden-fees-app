//
//  ContactView.swift
//  Hidden Fee App
//
//  Contact tab — support/feedback info for the user to reach out.
//

import SwiftUI

struct ContactView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Get in Touch")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(.white)
                        Text("Questions, feedback, or something looks off? We'd love to hear from you.")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    .padding(.top, 8)

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
                            // Replace with your App Store review URL once published.
                        }
                    }

                    HStack(spacing: 10) {
                        Image(systemName: "lock.shield")
                            .foregroundStyle(.green)
                        Text("Your documents stay on your device and are never shared without your permission.")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    .padding()
                    .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .background(Color.black.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
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
                    .frame(width: 36, height: 36)
                    .background(tint.opacity(0.18), in: RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.gray.opacity(0.6))
            }
            .padding(14)
            .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContactView()
}