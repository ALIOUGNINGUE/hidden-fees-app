//
//  SourceOptionsSheet.swift
//  Hidden Fee App
//
//  Standalone popup shown when the user taps the upload area —
//  lets them choose how to add a document (scan, photo library, or file).
//

import SwiftUI

struct SourceOptionsSheet: View {
    let docType: DocumentType
    let onScan: () -> Void
    let onUpload: () -> Void
    let onFile: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 6) {
                Text("Add \(docType.name)")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                Text("Scan a physical document or upload one you already have")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 8)

            VStack(spacing: 12) {
                SourceOptionRow(
                    icon: "camera.fill",
                    title: "Scan with Camera",
                    subtitle: "Use your camera to capture pages",
                    tint: docType.accentColor,
                    action: onScan
                )
                SourceOptionRow(
                    icon: "photo.on.rectangle",
                    title: "Upload from Library",
                    subtitle: "Choose screenshots or photos",
                    tint: docType.accentColor,
                    action: onUpload
                )
                SourceOptionRow(
                    icon: "folder.fill",
                    title: "Choose a File",
                    subtitle: "PDF or image from Files",
                    tint: docType.accentColor,
                    action: onFile
                )
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
        .preferredColorScheme(.dark)
    }
}

private struct SourceOptionRow: View {
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
    SourceOptionsSheet(docType: .creditCard, onScan: {}, onUpload: {}, onFile: {})
        .background(Color.black)
}