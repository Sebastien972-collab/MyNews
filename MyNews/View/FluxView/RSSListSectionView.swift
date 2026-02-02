////
////  RSSListSectionView.swift
////  MyNews
////
////  Created by Sébastien DAGUIN on 02/02/2026.
////
//
//
//struct RSSListSectionView: View {
//    @ObservedObject var linkManager: LinkManager
//    let header: String
//    let status: LinkStatus // Assure-toi que cela correspond à ton modèle
//    let icon: String
//    let color: Color
//    
//    var body: some View {
//        let filteredLinks = linkManager.fluxLinks.filter { $0.status == status }
//        
//        if !filteredLinks.isEmpty {
//            VStack(alignment: .leading, spacing: 10) {
//                HStack {
//                    Label(header, systemImage: icon)
//                        .font(.footnote.bold())
//                        .foregroundColor(color)
//                        .textCase(.uppercase)
//                    Spacer()
//                    Text("\(filteredLinks.count)")
//                        .font(.caption2.bold())
//                        .padding(.horizontal, 8)
//                        .padding(.vertical, 4)
//                        .background(color.opacity(0.1))
//                        .clipShape(Capsule())
//                }
//                .padding(.horizontal, 5)
//                
//                VStack(spacing: 1) {
//                    ForEach(filteredLinks) { link in
//                        HStack {
//                            Text(link.url)
//                                .font(.subheadline)
//                                .lineLimit(1)
//                            Spacer()
//                            Image(systemName: "chevron.right")
//                                .font(.caption2)
//                                .foregroundColor(.secondary)
//                        }
//                        .padding()
//                        .background(.ultraThinMaterial.opacity(0.5))
//                    }
//                }
//                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 16)
//                        .stroke(.white.opacity(0.2), lineWidth: 1)
//                )
//            }
//        }
//    }
//}
