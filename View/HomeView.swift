//
//  HomeView.swift
//  Hidden Fee App
//
//  Created by Everyone Can Code Chicago on 7/2/26.
//

import SwiftUI

struct HomeView: View {

    @State private var path: [FlowRoute] = []

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    heroSection
                    documentGrid
                    tipBanner
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
            .background(Color.black)
            .navigationBarHidden(true)
            .navigationDestination(for: FlowRoute.self) { route in
                switch route {
                case .upload(let docType):
                    DocumentUploadView(docType: docType)
                case .review, .results:
                    EmptyView()
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Sections

    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [Color(red: 0.2, green: 0.45, blue: 1.0),
                                 Color(red: 0.55, green: 0.2, blue: 0.85)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 54, height: 54)
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)
            }
            .padding(.top, 8)

            Text("Know what you\nsigned up for.")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.white)
                .lineSpacing(2)

            Text("Scan any contract to expose hidden fees, penalties, auto-renewals, and rate hikes — explained in plain English.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineSpacing(3)
        }
    }

    private var documentGrid: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("What are you scanning?")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(DocumentType.allTypes) { docType in
                    DocumentTypeCard(docType: docType)
                        .onTapGesture { path.append(.upload(docType)) }
                }
            }
        }
    }

    private var tipBanner: some View {
        HStack(spacing: 14) {
            Image(systemName: "doc.on.doc")
                .font(.title3)
                .foregroundStyle(.blue)
                .frame(width: 42, height: 42)
                .background(Color.blue.opacity(0.12), in: RoundedRectangle(cornerRadius: 11))

            VStack(alignment: .leading, spacing: 3) {
                Text("Scan every page")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                Text("Fees are often buried in appendices and footnotes.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.blue.opacity(0.08), in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.blue.opacity(0.2), lineWidth: 1))
    }
}

// MARK: - Document Type Card

private struct DocumentTypeCard: View {
    let docType: DocumentType

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: docType.iconName)
                .font(.title2)
                .foregroundStyle(docType.accentColor)
                .frame(width: 46, height: 46)
                .background(docType.accentColor.opacity(0.15), in: RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 3) {
                Text(docType.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Text(docType.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(docType.accentColor.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Route

enum FlowRoute: Hashable {
    case upload(DocumentType)
    case review
    case results
}

#Preview {
    HomeView()
}
