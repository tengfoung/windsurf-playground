import SwiftUI

struct StrategyMacroSection: View {
    let articles: [Article]
    let onViewAll: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeaderView(
              title: "Strategy & Macroeconomics"
            )
            
            if !articles.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(articles) { article in
                            ArticleCard(article: article, isCompact: true)
                                .frame(width: 280)
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                Text("No strategy articles available")
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Previews

struct StrategyMacroSection_Previews: PreviewProvider {
    static var previews: some View {
        let mockArticles = Array(repeating: Article.mock, count: 5)
        
        StrategyMacroSection(
            articles: mockArticles,
            onViewAll: {}
        )
        .previewLayout(.sizeThatFits)
    }
}
