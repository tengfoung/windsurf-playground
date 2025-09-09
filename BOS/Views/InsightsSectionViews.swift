import SwiftUI

// MARK: - Search Bar
struct SearchBar: View {
    @Binding var text: String
    @Binding var isSearching: Bool
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search for insights...", text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            if isSearching {
                Button("Cancel") {
                    text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .foregroundColor(.blue)
                .transition(.move(edge: .trailing))
                .animation(.default, value: isSearching)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.clear))
    }
}

// MARK: - Section Header
struct SectionHeaderView: View {
    let title: String
    let actionTitle: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Spacer()
            
            Button(action: action) {
                HStack(spacing: 4) {
                    Text(actionTitle)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Top Picks Section
struct TopPicksSection: View {
    let topPicks: [Article]
    let onSeeAll: () -> Void
    
    private var todayPick: Article? {
        topPicks.first
    }
    
    private var morePicks: [Article] {
        Array(topPicks.dropFirst().prefix(4))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeaderView(
                title: "Top Picks",
                actionTitle: "See All"
            ) {
                onSeeAll()
            }
            
            // Today's Top Pick
            if let pick = todayPick {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Today's Top Pick")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 16)
                    
                    ArticleCardView(
                        article: pick,
                        showIndicators: false,
                        imageHeight: 200
                    )
                }
            }
            
            // More Top Picks
            if !morePicks.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("More Top Picks")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(morePicks) { article in
                                ArticleCardView(
                                    article: article,
                                    showIndicators: false,
                                    imageHeight: 160,
                                    showDescription: false
                                )
                                //.frame(width: 280)
                            }
                        }
                        .padding(.horizontal)
                    }
                    //.padding(.horizontal, -16)
                }
            }
        }
        .padding(.vertical)
    }
}

// MARK: - Curated For You Section
struct CuratedForYouSection: View {
    let articles: [Article]
    let onSeeAll: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeaderView(
                title: "Curated for You",
                actionTitle: "View All"
            ) {
                onSeeAll()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(articles) { article in
                        ArticleCardView(
                            article: article,
                            showIndicators: true,
                            imageHeight: 100,
                            showDescription: true,
                            maxLines: 2
                        )
                        .frame(width: 300)
                    }
                }
                .padding(.horizontal)
            }
            //.padding(.horizontal, -16)
        }
        .padding(.vertical)
    }
}

// MARK: - Flagship Publications Section
struct FlagshipPublicationsSection: View {
    let articles: [Article]
    let onSeeAll: () -> Void
    
    private var featuredPublications: [String: Article] {
        var result: [String: Article] = [:]
        let categories = ["MIG", "CIO Weekly", "Morning Call", "FX Daily"]
        
        for category in categories {
            if let article = articles.first(where: { $0.category == category }) {
                result[category] = article
            }
        }
        
        return result
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeaderView(
                title: "Flagship Publications",
                actionTitle: "View All"
            ) {
                onSeeAll()
            }
            
            if featuredPublications.isEmpty {
                Text("No flagship publications available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(featuredPublications.keys.sorted()), id: \.self) { category in
                        if let article = featuredPublications[category] {
                            ArticleCardView(
                                article: article,
                                showIndicators: false,
                                showTags: false,
                                imageHeight: 120,
                                showDescription: true,
                                maxLines: 1
                            )
                        }
                    }
                }
            }
        }
        .padding(.vertical)
    }
}

// MARK: - Strategy & Macroeconomics Section
struct StrategyMacroSection: View {
    let articles: [Article]
    let onSeeAll: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeaderView(
                title: "Strategy & Macroeconomics",
                actionTitle: "View All"
            ) {
                onSeeAll()
            }
            
            if articles.isEmpty {
                Text("No strategy articles available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(articles) { article in
                            ArticleCardView(
                                article: article,
                                showIndicators: false,
                                imageHeight: 100,
                                showDescription: true,
                                maxLines: 2
                            )
                            .frame(width: 280)
                        }
                    }
                    .padding(.horizontal)
                }
                //.padding(.horizontal, -16)
            }
        }
        .padding(.vertical)
    }
}

// MARK: - Company Reports Section
struct CompanyReportsSection: View {
    let reports: [Article]
    let onSeeAll: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeaderView(
                title: "Company Reports",
                actionTitle: "View All"
            ) {
                onSeeAll()
            }
            
            if reports.isEmpty {
                Text("No company reports available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                VStack(spacing: 12) {
                    ForEach(reports) { report in
                        ArticleCardView(
                            article: report,
                            showIndicators: false,
                            showTags: true,
                            imageHeight: 100,
                            showDescription: true,
                            maxLines: 2
                        )
                    }
                }
            }
        }
        .padding(.vertical)
    }
}

// MARK: - Previews
struct InsightsSectionViews_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 0) {
                TopPicksSection(
                    topPicks: Article.sampleTopPicks,
                    onSeeAll: {}
                )
                
                Divider()
                
                CuratedForYouSection(
                    articles: Article.sampleCuratedList,
                    onSeeAll: {}
                )
                
                Divider()
                
                FlagshipPublicationsSection(
                    articles: Article.sampleFlagshipList,
                    onSeeAll: {}
                )
                
                Divider()
                
                StrategyMacroSection(
                    articles: Article.sampleStrategyList,
                    onSeeAll: {}
                )
                
                Divider()
                
                CompanyReportsSection(
                    reports: Article.sampleCompanyReports,
                    onSeeAll: {}
                )
            }
        }
    }
}
