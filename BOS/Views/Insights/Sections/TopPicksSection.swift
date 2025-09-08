import SwiftUI

struct TopPicksSection: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    let topPicks: [Article]
    let onViewAll: () -> Void
    let onSearch: () -> Void
    
    private let gradient = LinearGradient(
        gradient: Gradient(colors: [.black.opacity(0.7), .black.opacity(0.3)]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    var height: CGFloat {
        statusBarHeight + 360
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let topPick = topPicks.first {
                ZStack(alignment: .top) {
                    GeometryReader { geometry in
                        ZStack(alignment: .top) {
                            // Background Image with Gradient Overlay
                            if let imageUrl = topPick.imageUrl, let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: geometry.size.width, height: height)
                                            .clipped()
                                    default:
                                        Color.gray.opacity(0.3)
                                    }
                                }
                                .frame(width: geometry.size.width, height: height)
                                .overlay(gradient)
                            } else {
                                Color.gray.opacity(0.3)
                                    .frame(width: geometry.size.width, height: height)
                            }
                            
                            VStack(alignment: .leading, spacing: 0) {
                                
                                Color.clear
                                    .frame(height: statusBarHeight)
                                
                                // Search Bar at the very top
                                SearchInsightsView(
                                    searchText: $searchText,
                                    isSearching: $isSearching,
                                    onSearch: onSearch
                                )
                                .padding(.horizontal, 16)
                                .padding(.top, 8)
                                .padding(.bottom, 8)
                                
                                // Header with title and action buttons
                                HStack(alignment: .center) {
                                    // Title
                                    Text("TOP PICKS")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .padding(.leading, 20)
                                    
                                    Spacer()
                                    
                                    // Action Buttons
                                    HStack(spacing: 8) {
                                        Button(action: {}) {
                                            Image(systemName: "play.fill")
                                                .font(.system(size: 14))
                                                .foregroundColor(.white)
                                                .frame(width: 36, height: 36)
                                                .background(Color.white.opacity(0.2))
                                                .clipShape(Circle())
                                        }
                                        
                                        Button(action: {}) {
                                            Image(systemName: "square.and.arrow.up")
                                                .font(.system(size: 14))
                                                .foregroundColor(.white)
                                                .frame(width: 36, height: 36)
                                                .background(Color.white.opacity(0.2))
                                                .clipShape(Circle())
                                        }
                                    }
                                    .padding(.trailing, 16)
                                }
                                .padding(.top, 8)
                                .padding(.bottom, 16)
                                
                                Spacer()
                                
                                // Article Content
                                VStack(alignment: .leading, spacing: 16) {
                                    // Title and Company
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(topPick.title)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .lineLimit(2)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                        if let company = topPick.company {
                                            Text(company)
                                                .font(.subheadline)
                                                .foregroundColor(.white.opacity(0.9))
                                        }
                                    }
                                    
                                    // Description
                                    if let description = topPick.description {
                                        Text(description)
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.9))
                                            .lineLimit(3)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    
                                    // Tags
                                    if !topPick.tags.isEmpty {
                                        HStack(spacing: 8) {
                                            ForEach(topPick.tags.prefix(2)) { tag in
                                                Text(tag.name.uppercased())
                                                    .font(.caption2)
                                                    .fontWeight(.medium)
                                                    .padding(.horizontal, 10)
                                                    .padding(.vertical, 4)
                                                    .background(Color.white.opacity(0.2))
                                                    .foregroundColor(.white)
                                                    .cornerRadius(10)
                                            }
                                        }
                                        .padding(.bottom, 12)
                                    }
                                    
                                    // Date and Type
                                    HStack {
                                        if let date = DateFormatter.yyyyMMdd.date(from: topPick.date) {
                                            Text(DateFormatter.MMMdyyyy.string(from: date).uppercased())
                                                .font(.caption2)
                                                .foregroundColor(.white.opacity(0.8))
                                        }
                                        
                                        if let type = topPick.type {
                                            Text("•")
                                                .font(.caption2)
                                                .foregroundColor(.white.opacity(0.8))
                                            
                                            Text(type.uppercased())
                                                .font(.caption2)
                                                .foregroundColor(.white.opacity(0.8))
                                        }
                                    }
                                    .padding(.bottom, 16)
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .frame(width: geometry.size.width)
                        .background(Color.white)
                    }
                }
                .frame(height: height)
            }
        }
    }
}

// MARK: - Previews

struct TopPicksSection_Previews: PreviewProvider {
    @State static var searchText = ""
    @State static var isSearching = false
    
    static var previews: some View {
        var mockArticle = Article.mock
        mockArticle.company = "CEMEX"
        mockArticle.title = "CEMEX FY22 Review: Just one step more for IG"
        mockArticle.description = "CEMEX's 2022 performance shows strong progress with EBITDA growing 8% YoY to $3.2B, driven by pricing actions and cost discipline. The company's net debt/EBITDA improved to 3.1x from 3.4x in 2021, moving closer to its investment grade target of below 3.0x."
        mockArticle.type = "Research Report"
        mockArticle.tags = [
            Tag(id: "1", name: "Fixed income", type: "asset"),
            Tag(id: "2", name: "Others", type: "category")
        ]
        
        return TopPicksSection(
            searchText: $searchText,
            isSearching: $isSearching,
            topPicks: [mockArticle],
            onViewAll: {},
            onSearch: {}
        )
        .previewLayout(.sizeThatFits)
        .background(Color(.systemBackground))
        .previewDisplayName("Top Picks Section")
    }
}
