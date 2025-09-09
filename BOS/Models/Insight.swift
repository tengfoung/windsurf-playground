import Foundation

// MARK: - Main Models

struct Insight: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let hook: String
    let description: String
    let date: String
    let tags: [String]
    let imageUrl: String?
    let hasVideo: Bool?
    let videoUrl: String?
    let category: String?
    let company: String?
    let indicators: Indicators?
    
    enum CodingKeys: String, CodingKey {
        case id, title, hook, description, date, tags, category, company, indicators
        case imageUrl = "imageUrl"
        case hasVideo = "hasVideo"
        case videoUrl = "videoUrl"
    }
    
    // For testing and previews
    static func == (lhs: Insight, rhs: Insight) -> Bool {
        lhs.id == rhs.id
    }
}

struct Indicators: Codable {
    let onHoldings: Bool
    let onSubscription: Bool
    let onWatchlist: Bool
    
    enum CodingKeys: String, CodingKey {
        case onHoldings = "onHoldings"
        case onSubscription = "onSubscription"
        case onWatchlist = "onWatchlist"
    }
}

// MARK: - API Response Models

struct SearchResponse: Codable {
    let results: [Insight]
}

struct TopPicksResponse: Codable {
    let topPicks: [Insight]
    
    enum CodingKeys: String, CodingKey {
        case topPicks = "topPicks"
    }
}

struct CuratedResponse: Codable {
    let curated: [Insight]
}

struct FlagshipResponse: Codable {
    let flagship: [Insight]
}

struct StrategyResponse: Codable {
    let strategy: [Insight]
}

struct CompanyReportsResponse: Codable {
    let companyReports: [Insight]
    
    enum CodingKeys: String, CodingKey {
        case companyReports = "companyReports"
    }
}

// MARK: - Sample Data
#if DEBUG
extension Insight {
    static let sampleSearchResults: [Insight] = [
        Insight(
            id: "ART123",
            title: "Global Market Outlook",
            hook: "Short market summary...",
            description: "Detailed insights about the current global market trends and future predictions.",
            date: "2025-08-20",
            tags: ["Equities", "Strategy"],
            imageUrl: "https://media.istockphoto.com/id/1341853306/photo/hand-holding-virtual-world-with-copy-space-and-blue-bokeh-background-for-technology.jpg?s=612x612&w=0&k=20&c=DKWp5G5ArntF4meXBZgBA-z4rJykmZ6Y2qbi8gl-WLU=",
            hasVideo: false,
            videoUrl: nil,
            category: nil,
            company: nil,
            indicators: nil
        )
    ]
    
    static let sampleTopPicks: [Insight] = [
        Insight(
            id: "TP001",
            title: "Emerging Markets Opportunity",
            hook: "Key highlight of today...",
            description: "In-depth discussion about emerging market opportunities and risks.",
            date: "2025-09-01",
            tags: ["TopPick"],
            imageUrl: "https://media.istockphoto.com/id/1424617746/photo/targeting-the-business-concept-businessman-touch-red-arrow-dart-to-the-virtual-target.jpg?s=612x612&w=0&k=20&c=EF3KkM7Z3km4YmgXchACZTGbU-NzZbAq6ca7Saeo_-k=",
            hasVideo: true,
            videoUrl: "https://example.com/video.mp4",
            category: nil,
            company: nil,
            indicators: nil
        )
    ]
    
    static let sampleCurated: [Insight] = [
        Insight(
            id: "CU123",
            title: "Tech Sector Insights",
            hook: "Focus on technology...",
            description: "Analysis of Q2 results and future outlook for the technology sector.",
            date: "2025-08-30",
            tags: ["Technology"],
            imageUrl: "https://media.istockphoto.com/id/1465618017/photo/businessmen-investor-think-before-buying-stock-market-investment-using-smartphone-to-analyze.jpg?s=612x612&w=0&k=20&c=YNEkfoME1jbz6FUJImxCQtaGZZntrf7u-Byxmgk4pOY=",
            hasVideo: false,
            videoUrl: nil,
            category: nil,
            company: nil,
            indicators: Indicators(onHoldings: true, onSubscription: false, onWatchlist: true)
        )
    ]
    
    static let sampleFlagship: [Insight] = [
        Insight(
            id: "MIG001",
            title: "Monthly Investment Guide",
            hook: "Investment strategies...",
            description: "Comprehensive guide to investment strategies for the current month.",
            date: "2025-09-05",
            tags: ["MIG"],
            imageUrl: "https://media.istockphoto.com/id/1397011551/photo/stack-of-silver-coins-with-trading-chart-in-financial-concepts-and-financial-investment.jpg?s=612x612&w=0&k=20&c=spnvXHk8mNS7GAaz_Um16mllWjHa6oMrTwekQiR8qqU=",
            hasVideo: false,
            videoUrl: nil,
            category: "MIG",
            company: nil,
            indicators: nil
        ),
        Insight(
            id: "CIO001",
            title: "Weekly CIO Update",
            hook: "Market direction...",
            description: "Weekly update from the Chief Investment Officer on market direction.",
            date: "2025-09-02",
            tags: ["CIO Weekly"],
            imageUrl: "https://media.istockphoto.com/id/1987166734/photo/meeting-whiteboard-and-senior-business-woman-in-boardroom-with-team-for-training-or-coaching.jpg?s=612x612&w=0&k=20&c=izeQTdEEjNAL6qN1cjWf1NExrAFBGttYOIRmwNDCQss=",
            hasVideo: false,
            videoUrl: nil,
            category: "CIO Weekly",
            company: nil,
            indicators: nil
        )
    ]
    
    static let sampleStrategy: [Insight] = [
        Insight(
            id: "SM001",
            title: "Global Macro Outlook",
            hook: "Macro trends this quarter...",
            description: "Extended analysis of global macroeconomic trends and their implications.",
            date: "2025-09-04",
            tags: ["Macroeconomics"],
            imageUrl: "https://media.istockphoto.com/id/1341853306/photo/hand-holding-virtual-world-with-copy-space-and-blue-bokeh-background-for-technology.jpg?s=612x612&w=0&k=20&c=DKWp5G5ArntF4meXBZgBA-z4rJykmZ6Y2qbi8gl-WLU=",
            hasVideo: false,
            videoUrl: nil,
            category: "Strategy",
            company: nil,
            indicators: nil
        )
    ]
    
    static let sampleCompanyReports: [Insight] = [
        Insight(
            id: "CR001",
            title: "Q3 Earnings Review",
            hook: "Highlights from Q3...",
            description: "Detailed review of Q3 earnings and performance metrics.",
            date: "2025-09-06",
            tags: ["Equities", "BankView"],
            imageUrl: "https://media.istockphoto.com/id/174628030/photo/report.jpg?s=612x612&w=0&k=20&c=f5o6EaPA8cztWiZ7AIONax071B85ZZZJ5PYdcr6x1yA=",
            hasVideo: false,
            videoUrl: nil,
            category: "Company Report",
            company: "Apple Inc.",
            indicators: nil
        )
    ]
}
#endif
