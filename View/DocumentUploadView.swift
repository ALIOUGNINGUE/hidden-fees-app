//
//  DocumentUploadView.swift
//  Hidden Fee App
//
//  Created by Everyone Can Code Chicago on 7/2/26.
//

import SwiftUI
import PhotosUI
import VisionKit

struct DocumentUploadView: View {
    let docType: DocumentType

    @Environment(\.dismiss) private var dismiss

    @State private var pages: [UIImage] = []

    // Drives the "scan or upload" popup shown when the upload area is tapped.
    @State private var isShowingSourceOptions = false

    @State private var isShowingPhotoPicker = false
    @State private var isShowingScanner = false
    @State private var isShowingFilePicker = false
    @State private var photoSelection: [PhotosPickerItem] = []

    @State private var isShowingResults = false
    @State private var scannerViewModel = ScannerViewModel()
    @State private var recognizedText: [String]?

    var body: some View {
        VStack{
            VStack() {
                HStack(){
                    Image(systemName: docType.iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30, alignment: .center)
                        .clipped()
                        .font(.title3)
                        .foregroundStyle(docType.accentColor)
                        .padding(5)
                        .background(docType.accentColor.opacity(0.18), in: RoundedRectangle(cornerRadius: 8))
                    Text(docType.name)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            ScrollView {
                VStack(spacing: 24) {
                    uploadArea
                    if !pages.isEmpty {
                        pageThumbnails
                    }
                    Spacer(minLength: 40)
                    Button {
                        startScan()
                    } label: {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Text(pages.isEmpty ? "Add pages to scan" : "Scan \(pages.count) page\(pages.count == 1 ? "" : "s")")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(docType.accentColor)
                    .disabled(pages.isEmpty)
                }
            }
        }
        .preferredColorScheme(.dark)
        // Tapping the upload area presents this popup instead of jumping
        // straight to the photo picker.
        .sheet(isPresented: $isShowingSourceOptions) {
            SourceOptionsSheet(
                docType: docType,
                onScan: {
                    isShowingSourceOptions = false
                    // Wait for the sheet to fully dismiss before presenting the
                    // camera full screen — presenting both at once can crash.
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        isShowingScanner = true
                    }
                },
                onUpload: {
                    isShowingSourceOptions = false
                    isShowingPhotoPicker = true
                },
                onFile: {
                    isShowingSourceOptions = false
                    isShowingFilePicker = true
                }
            )
            .presentationDetents([.height(320)])
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(24)
            .presentationBackground(.black)
        }
        // Camera fills the whole screen, like the system Notes/Files scanner.
        .fullScreenCover(isPresented: $isShowingScanner) {
            ScannerView { recognizedText in
                isShowingScanner = false
                handleScanResult(recognizedText)
            }
            .ignoresSafeArea()
        }
    }
    private var uploadArea: some View {
        Button {
            isShowingSourceOptions = true
        } label: {
            VStack(spacing: 12) {
                Image(systemName: "photo.badge.plus")
                    .font(.system(size: 32))
                    .foregroundStyle(.gray)
                Text("Add document screenshots")
                    .font(.headline)
                    .foregroundStyle(.white)
                Text("Every page counts — add the full document for best results")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 36)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [8, 6]))
                    .foregroundStyle(.gray.opacity(0.5))
            )
        }
    }
    private var flagSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("WE'LL FLAG")
                .font(.caption.weight(.semibold))
                .tracking(1)
                .foregroundStyle(.gray)
            let cols = [GridItem(.flexible()), GridItem(.flexible())]
            LazyVGrid(columns: cols, alignment: .leading, spacing: 10) {
                ForEach(docType.flagLabels) { label in
                    HStack(spacing: 8) {
                        Circle()
                            .fill(label.dotColor)
                            .frame(width: 8, height: 8)
                        Text(label.text)
                            .font(.subheadline)
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 14))
    }
    private var pageThumbnails: some View {
        Text("hello")
    }
    private func startScan(){
        guard !pages.isEmpty else { return }
        Task {
            await scannerViewModel.process(images: pages)
            if case .review = scannerViewModel.state {
                isShowingResults = true
            }
        }
    }

    /// Called after the camera finishes. `recognizedText` is nil if the user
    /// cancelled or recognition failed — otherwise one string per scanned page.
    private func handleScanResult(_ recognizedText: [String]?) {
        guard let recognizedText, !recognizedText.isEmpty else { return }

        self.recognizedText = recognizedText

        // TextRecognizer already ran OCR, so we skip process(images:) entirely
        // and hand the combined text straight to the model for review.
        let combinedText = recognizedText.joined(separator: "\n\n")
        scannerViewModel.loadSampleText(combinedText)
        isShowingResults = true
    }
}
#Preview {
    DocumentUploadView(docType: .creditCard)
}
