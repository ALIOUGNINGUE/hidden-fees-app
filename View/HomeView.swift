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
               VStack(alignment: .leading, spacing: 24) {
                   VStack(alignment: .leading, spacing: 8) {
                       Label("CONTRACT SCANNER", systemImage: "eye")
                           .font(.caption.weight(.bold))
                           .tracking(2)
                           .foregroundStyle(Color.accentColor)

                       Text("Know what you\nsigned up for.")
                           .font(.system(size: 32, weight: .bold))
                           .foregroundStyle(.white)

                       Text("Upload screenshots of any contract. We flag late fees, penalties, rate hikes, auto-renewals & cancellation terms.")
                           .font(.subheadline)
                           .foregroundStyle(.gray)
                   }
                   .padding(.top, 8)
                   VStack(alignment: .leading, spacing: 12) {
                       Text("WHAT ARE YOU SCANNING?")
                           .font(.caption.weight(.semibold))
                           .tracking(1)
                           .foregroundStyle(.gray)
                       LazyVGrid(columns: columns, spacing: 12) {
                           ForEach(DocumentType.allTypes) { docType in
                               DocumentTypeCard(docType: docType)
                                   .onTapGesture { path.append(.upload(docType)) }
                           }
                       }
                   }
                   HStack(spacing: 10) {
                       Image(systemName: "bolt.fill")
                           .foregroundStyle(.yellow)
                       Text("Multi-page documents? Add every page, fees are often buried in appendices and footnotes.")
                           .font(.caption)
                           .foregroundStyle(.gray)
                   }
                   .padding()
                   .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 12))
               }
               .padding(.horizontal)
               .padding(.bottom, 24)
           }
           
           // .fullScreenCover(item: $selectedType) { docType in
            // DocumentUploadView(place holder)
           .background(Color.black)
           .navigationBarHidden(true)
           .navigationDestination(for: FlowRoute.self) { route in
               switch route {
               case .upload(let docType):
                   DocumentUploadView(docType: docType)
               case .review:
                   EmptyView()
               case .results:
                   EmptyView()
               }
           }

       }
       .preferredColorScheme(.dark)
   }
}

private struct DocumentTypeCard: View {
   let docType: DocumentType

   var body: some View {
       VStack(alignment: .leading, spacing: 8) {
           Image(systemName: docType.iconName)
               .font(.title3)
               .foregroundStyle(docType.accentColor)
               .padding(8)
               .background(docType.accentColor.opacity(0.18), in: RoundedRectangle(cornerRadius: 8))

           Text(docType.name)
               .font(.subheadline.weight(.semibold))
               .foregroundStyle(.white)

           Text(docType.subtitle)
               .font(.caption2.monospaced())
               .foregroundStyle(.gray)
               .lineLimit(3)
       }
       .frame(maxWidth: .infinity, alignment: .leading)
       .padding(14)
       .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 14))
   }
}

enum FlowRoute: Hashable {
   case upload(DocumentType)
   case review
   case results
}

#Preview {
   HomeView()
}
