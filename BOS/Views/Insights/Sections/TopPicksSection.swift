import SwiftUI

struct TopPicksSection: View {
    let topPicks: [Article]
    let moreTopPicks: [Article]
    let onViewAll: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            SectionHeaderView(
                title: "Top Picks"
            )
            
            // Today's Top Pick
            if let topPick = topPicks.first {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Today's Top Pick")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ArticleCard(article: topPick, isCompact: false)
                        .padding(.horizontal)
                }
            }
            
            // More Top Picks
            if !moreTopPicks.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("More Top Picks")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(moreTopPicks) { article in
                                ArticleCard(article: article, isCompact: true)
                                    .frame(width: 280)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Previews

struct TopPicksSection_Previews: PreviewProvider {
    static var previews: some View {
        let mockArticle = Article.mock
        let mockArticles = Array(repeating: Article.mock, count: 3)
        
        TopPicksSection(
            topPicks: [mockArticle],
            moreTopPicks: mockArticles,
            onViewAll: {}
        )
        .previewLayout(.sizeThatFits)
    }
}
