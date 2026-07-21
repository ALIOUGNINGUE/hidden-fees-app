//
//  DocumentUploadView.swift
//  Hidden Fee App
//
//  Created by Everyone Can Code Chicago on 7/2/26.
//

import SwiftUI
import PhotosUI
import VisionKit
import Vision
import PDFKit

struct DocumentUploadView: View {
    let docType: DocumentType
    
    @Environment(\.dismiss) private var dismiss
    @Environment(ScanHistory.self) private var scanHistory
    
    @State private var pages: [UIImage] = []
    
    // Drives the "scan or upload" popup shown when the upload area is tapped.
    @State private var isShowingSourceOptions = false
    
    @State private var isShowingPhotoPicker = false
    @State private var isShowingScanner = false
    @State private var isShowingFilePicker = false
    @State private var photoSelection: [PhotosPickerItem] = []
    
    @State private var isShowingResults = false
    @State private var isProcessing = false
    @State private var shouldReturnHome = false
    @State private var scannerViewModel = ScannerViewModel()
    @State private var recognizedText: [String]?
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                uploadArea
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
            }

            // Pinned scan button
            VStack(spacing: 0) {
                Divider().background(Color.white.opacity(0.1))
                Button {
                    runOCRAndAnalyze()
                } label: {
                    HStack(spacing: 8) {
                        if isProcessing {
                            ProgressView()
                                .tint(.white)
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "sparkle.magnifyingglass")
                        }
                        Text(isProcessing ? "Analyzing…" : (pages.isEmpty ? "Add pages to scan" : "Scan \(pages.count) page\(pages.count == 1 ? "" : "s")"))
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 2)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(docType.accentColor)
                .disabled(pages.isEmpty || isProcessing)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(Color.black)
        }
        .background(Color.black)
        .navigationTitle(docType.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.black, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
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
        .fullScreenCover(isPresented: $isShowingResults) {
            NavigationStack {
                if let report = scannerViewModel.report {
                    ResultsView(report: report)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Done") {
                                    shouldReturnHome = true
                                    isShowingResults = false
                                }
                            }
                        }
                } else {
                    ProgressView()
                }
            }
        }
        .photosPicker(isPresented: $isShowingPhotoPicker, selection: $photoSelection, matching: .images)
        .onChange(of: photoSelection) { _, newItems in
            guard !newItems.isEmpty else { return }
            Task {
                var loaded: [UIImage] = []
                for item in newItems {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        loaded.append(image)
                    }
                }
                pages.append(contentsOf: loaded)
                photoSelection = []
            }
        }
        .onChange(of: isShowingResults) { _, isShowing in
            if !isShowing && shouldReturnHome {
                dismiss()
            }
        }
        .fileImporter(
            isPresented: $isShowingFilePicker,
            allowedContentTypes: [.pdf, .image],
            allowsMultipleSelection: true
        ) { result in
            guard let urls = try? result.get() else { return }
            var fileData: [(Data, String)] = []
            for url in urls {
                let accessing = url.startAccessingSecurityScopedResource()
                if let data = try? Data(contentsOf: url) {
                    fileData.append((data, url.pathExtension.lowercased()))
                }
                if accessing { url.stopAccessingSecurityScopedResource() }
            }
            Task {
                var loaded: [UIImage] = []
                for (data, ext) in fileData {
                    if ext == "pdf", let pdf = PDFDocument(data: data) {
                        for i in 0..<pdf.pageCount {
                            if let page = pdf.page(at: i) {
                                loaded.append(page.thumbnail(of: CGSize(width: 1200, height: 1600), for: .mediaBox))
                            }
                        }
                    } else if let image = UIImage(data: data) {
                        loaded.append(image)
                    }
                }
                pages.append(contentsOf: loaded)
            }
        }
    }
    private var uploadArea: some View {
        Group {
            if pages.isEmpty {
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
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("\(pages.count) page\(pages.count == 1 ? "" : "s") added")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white)
                        Spacer()
                        Button {
                            isShowingSourceOptions = true
                        } label: {
                            Label("Add more", systemImage: "plus")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(docType.accentColor)
                        }
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(pages.indices, id: \.self) { i in
                                Image(uiImage: pages[i])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 110)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .overlay(alignment: .topTrailing) {
                                        Button {
                                            pages.remove(at: i)
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundStyle(.white)
                                                .background(Color.black.opacity(0.5), in: Circle())
                                        }
                                        .padding(4)
                                    }
                            }
                        }
                    }
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [8, 6]))
                        .foregroundStyle(docType.accentColor.opacity(0.5))
                )
            }
        }
    }
    
    private func handleScanResult(_ recognizedText: [String]?) {
        guard let recognizedText, !recognizedText.isEmpty else { return }

        self.recognizedText = recognizedText
        let combinedText = recognizedText.joined(separator: "\n\n")

        Task {
            await scannerViewModel.analyze(text: combinedText, documentType: docType)
            isProcessing = false
            if case .review = scannerViewModel.state, let report = scannerViewModel.report {
                scanHistory.add(report)
                isShowingResults = true
            }
        }
    }

    private func runOCRAndAnalyze() {
        let cgImages = pages.compactMap { $0.cgImage }
        guard !cgImages.isEmpty else { return }

        isProcessing = true
        Task {
            let texts = await Task.detached(priority: .userInitiated) {
                var results: [String] = []
                for image in cgImages {
                    let request = VNRecognizeTextRequest()
                    request.usesLanguageCorrection = true
                    let handler = VNImageRequestHandler(cgImage: image, options: [:])
                    try? handler.perform([request])
                    let text = request.results?
                        .compactMap { $0.topCandidates(1).first?.string }
                        .joined(separator: "\n") ?? ""
                    results.append(text)
                }
                return results
            }.value
            handleScanResult(texts)
        }
    }
}
#Preview {
    DocumentUploadView(docType: .creditCard)
        .environment(ScanHistory())
}
