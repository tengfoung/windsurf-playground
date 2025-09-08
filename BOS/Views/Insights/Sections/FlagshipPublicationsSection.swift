import SwiftUI

struct FlagshipPublicationsSection: View {
    let articles: [Article]
    let onViewAll: () -> Void
    
    // Group articles by their category
    private var groupedArticles: [String: [Article]] {
        var result: [String: [Article]] = [:]
        
        for article in articles {
            let category = article.category ?? "Other"
            if result[category] == nil {
                result[category] = []
            }
            result[category]?.append(article)
        }
        
        return result
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeaderView(
                title: "Flagship Publications"
            )
            
            if !groupedArticles.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(Array(groupedArticles.keys.sorted()), id: \.self) { category in
                            if let article = groupedArticles[category]?.first {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(category)
                                        .font(.headline)
                                        .padding(.horizontal, 4)
                                    
                                    ArticleCard(article: article, isCompact: true)
                                        .frame(width: 280)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                Text("No flagship publications available")
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Previews

struct FlagshipPublicationsSection_Previews: PreviewProvider {
    static var previews: some View {
        let mockArticle1 = Article.mock
        let mockArticle2 = Article.mockWithVideo
        
        let articles = [
            mockArticle1,
            mockArticle2,
            mockArticle1,
            mockArticle2
        ]
        
        FlagshipPublicationsSection(
            articles: articles,
            onViewAll: {}
        )
        .previewLayout(.sizeThatFits)
    }
}
