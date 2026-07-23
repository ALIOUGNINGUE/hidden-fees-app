//
//  SettingsView.swift
//  Hidden Fee App
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(VoiceReaderService.self) private var voiceReader
    @AppStorage("textSizeIndex") private var textSizeIndex: Double = 2.0

    private let sizeLabels = ["Small", "Medium", "Default", "Large", "Extra Large"]

    var body: some View {
        @Bindable var voiceReader = voiceReader
        return NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    // MARK: Voice Reader
                    VStack(alignment: .leading, spacing: 12) {
                        sectionLabel("Voice Reader")

                        HStack(spacing: 14) {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.title3)
                                .foregroundStyle(.purple)
                                .frame(width: 44, height: 44)
                                .background(Color.purple.opacity(0.15), in: RoundedRectangle(cornerRadius: 12))

                            VStack(alignment: .leading, spacing: 3) {
                                Text("Read Screen Aloud")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.white)
                                Text("Reads the content of each screen as you navigate")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineSpacing(2)
                                    .fixedSize(horizontal: false, vertical: true)
                            }

                            Spacer()

                            Toggle("", isOn: $voiceReader.isEnabled)
                                .labelsHidden()
                                .tint(.purple)
                        }
                        .padding(16)
                        .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 14))
                    }

                    // MARK: Text Size
                    VStack(alignment: .leading, spacing: 12) {
                        sectionLabel("Text Size")

                        VStack(spacing: 16) {
                            HStack(spacing: 12) {
                                Text("A")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .frame(width: 20)

                                Slider(value: $textSizeIndex, in: 0...4, step: 1)
                                    .tint(.blue)

                                Text("A")
                                    .font(.title2.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                    .frame(width: 30)
                            }

                            Text(sizeLabels[Int(textSizeIndex)])
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding(16)
                        .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
            .background(Color.black)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(.white)
                }
            }
        }
        .dynamicTypeSize(typeSize(for: textSizeIndex))
        .preferredColorScheme(.dark)
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.caption.weight(.bold))
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
            .tracking(0.5)
    }
}

func typeSize(for index: Double) -> DynamicTypeSize {
    switch Int(index) {
    case 0: return .small
    case 1: return .medium
    case 3: return .xLarge
    case 4: return .xxLarge
    default: return .large
    }
}

#Preview {
    SettingsView()
        .environment(VoiceReaderService())
}
