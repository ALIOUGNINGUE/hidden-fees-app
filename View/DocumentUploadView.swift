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
 
    @State private var isShowingPhotoPicker = false
    @State private var isShowingScanner = false
    @State private var isShowingFilePicker = false
    @State private var photoSelection: [PhotosPickerItem] = []
 
    @State private var isShowingResults = false
    @State private var scannerViewModel = ScannerViewModel()
    
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
            
        }.preferredColorScheme(.dark)
    }
    private var uploadArea: some View {
        Button {
            isShowingPhotoPicker = true
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
        .contextMenu {
            Button {
                isShowingPhotoPicker = true
            } label: {
                Label("Photo Library", systemImage: "photo.on.rectangle")
            }
            Button {
                isShowingScanner = true
            } label: {
                Label("Scan with Camera", systemImage: "camera")
            }
            Button {
                isShowingFilePicker = true
            } label: {
                Label("Choose File", systemImage: "folder")
            }
        }
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
}

#Preview {
    DocumentUploadView(docType: .creditCard)
}
