import Foundation

// MARK: - Main Article Model
struct Article: Identifiable, Codable {
    var id: String
    var title: String
    var hook: String
    var description: String?
    var date: String
    var imageUrl: String?
    var videoUrl: String?
    var category: String?
    var company: String?
    var type: String?
    var tags: [Tag]
    var indicators: Indicators?
    
    // Computed property to check if article has video
    var hasVideo: Bool {
        return videoUrl != nil && !(videoUrl?.isEmpty ?? true)
    }
    
    // Mock data for previews
    static var mock: Article {
        Article(
            id: "MOCK001",
            title: "Sample Article Title",
            hook: "This is a sample hook that provides a brief summary of the article content.",
            description: "This is a detailed description of the article that provides more context and information about the content. It can span multiple lines and will be truncated in the UI.",
            date: "2025-09-08",
            imageUrl: "https://digital.bankofsingapore.com/assets/images/Apollo/Jan2024_Equity_Default.jpg",
            videoUrl: nil,
            category: "Research",
            company: nil,
            type: "article",
            tags: [
                Tag(id: "1", name: "Equities", type: "sector"),
                Tag(id: "2", name: "Technology", type: "industry")
            ],
            indicators: Indicators(onHoldings: true, onWatchlist: false, onSubscription: true)
        )
    }
    
    // Mock data for video content
    static var mockWithVideo: Article {
        var mock = Article.mock
        mock.videoUrl = "https://example.com/sample.mp4"
        return mock
    }
}

// MARK: - Tag Model
struct Tag: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let type: String?
}

// MARK: - Indicators Model
struct Indicators: Codable {
    let onHoldings: Bool
    let onWatchlist: Bool
    let onSubscription: Bool
    
    enum CodingKeys: String, CodingKey {
        case onHoldings = "on_holdings"
        case onWatchlist = "on_watchlist"
        case onSubscription = "on_subscription"
    }
}

// MARK: - API Response Models
struct SearchResponse: Codable {
    let results: [Article]
}

struct TopPicksResponse: Codable {
    let topPicks: [Article]
    
    enum CodingKeys: String, CodingKey {
        case topPicks = "topPicks"
    }
}

struct CuratedResponse: Codable {
    let curated: [Article]
}

struct FlagshipResponse: Codable {
    let flagship: [Article]
}

struct StrategyResponse: Codable {
    let strategy: [Article]
}

struct CompanyReportsResponse: Codable {
    let companyReports: [Article]
    
    enum CodingKeys: String, CodingKey {
        case companyReports = "companyReports"
    }
}
