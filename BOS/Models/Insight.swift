import Foundation

// MARK: - Main Article Model
struct Article: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let hook: String
    let description: String
    let date: String
    let tags: [String]
    let imageUrl: String?
    let videoUrl: String?
    let hasVideo: Bool?
    let indicators: Indicators?
    let category: String?
    let company: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, hook, description, date, tags, imageUrl, videoUrl, hasVideo, indicators, category, company
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: date) {
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
        return date
    }
}

// MARK: - Indicators Model
struct Indicators: Codable, Equatable {
    let onHoldings: Bool
    let onSubscription: Bool
    let onWatchlist: Bool
    
    enum CodingKeys: String, CodingKey {
        case onHoldings, onSubscription, onWatchlist
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

// MARK: - Sample Data
#if DEBUG
extension Article {
    // MARK: - Sample Collections
    
    static var sampleTopPicks: [Article] {
        [
            Article(
                id: "TP001",
                title: "Emerging Markets Opportunity",
                hook: "Key highlight of today...",
                description: "In-depth discussion about emerging market trends and opportunities...",
                date: "2025-09-01",
                tags: ["TopPick"],
                imageUrl: "https://media.istockphoto.com/id/1424617746/photo/targeting-the-business-concept-businessman-touch-red-arrow-dart-to-the-virtual-target.jpg?s=612x612&w=0&k=20&c=EF3KkM7Z3km4YmgXchACZTGbU-NzZbAq6ca7Saeo_-k=",
                videoUrl: "https://example.com/video.mp4",
                hasVideo: true,
                indicators: nil,
                category: "Featured",
                company: nil
            ),
            Article(
                id: "SM001",
                title: "Global Macro Outlook",
                hook: "Macro trends this quarter...",
                description: "Extended analysis of global macroeconomic trends...",
                date: "2025-09-04",
                tags: ["Macroeconomics", "Strategy"],
                imageUrl: "https://media.istockphoto.com/id/1341853306/photo/hand-holding-virtual-world-with-copy-space-and-blue-bokeh-background-for-technology.jpg?s=612x612&w=0&k=20&c=DKWp5G5ArntF4meXBZgBA-z4rJykmZ6Y2qbi8gl-WLU=",
                videoUrl: nil,
                hasVideo: false,
                indicators: nil,
                category: "Strategy",
                company: nil
            ),
            Article(
                id: "ER001",
                title: "Q3 Earnings Review",
                hook: "Highlights from Q3 earnings...",
                description: "Detailed analysis of Q3 financial performance...",
                date: "2025-09-06",
                tags: ["Earnings", "Analysis"],
                imageUrl: "https://media.istockphoto.com/id/1369763061/photo/quarterly-report-concept.jpg?s=612x612&w=0&k=20&c=tLmEtRTHFRKkKI-FbsgYKPqzDz-jfJ4oVAbcWahCL5g=",
                videoUrl: nil,
                hasVideo: false,
                indicators: nil,
                category: "Earnings",
                company: "Apple Inc."
            )
        ]
    }
    
    static var sampleCuratedList: [Article] {
        [
            Article(
                id: "CU123",
                title: "Tech Sector Insights",
                hook: "Focus on technology sector growth...",
                description: "Analysis of Q2 results and future outlook for the technology sector...",
                date: "2025-08-30",
                tags: ["Technology"],
                imageUrl: "https://media.istockphoto.com/id/1465618017/photo/businessmen-investor-think-before-buying-stock-market-investment-using-smartphone-to-analyze.jpg?s=612x612&w=0&k=20&c=YNEkfoME1jbz6FUJImxCQtaGZZntrf7u-Byxmgk4pOY=",
                videoUrl: nil,
                hasVideo: false,
                indicators: Indicators(onHoldings: true, onSubscription: false, onWatchlist: true),
                category: "Technology",
                company: nil
            ),
            Article(
                id: "SM001",
                title: "Global Macro Outlook",
                hook: "Macro trends this quarter...",
                description: "Extended analysis of global macroeconomic trends...",
                date: "2025-09-04",
                tags: ["Macroeconomics", "Strategy"],
                imageUrl: "https://media.istockphoto.com/id/1341853306/photo/hand-holding-virtual-world-with-copy-space-and-blue-bokeh-background-for-technology.jpg?s=612x612&w=0&k=20&c=DKWp5G5ArntF4meXBZgBA-z4rJykmZ6Y2qbi8gl-WLU=",
                videoUrl: nil,
                hasVideo: false,
                indicators: nil,
                category: "Strategy",
                company: nil
            ),
            Article(
                id: "CU124",
                title: "Sustainable Investing",
                hook: "The future of ESG investing...",
                description: "Analysis of environmental, social, and governance factors...",
                date: "2025-09-02",
                tags: ["ESG", "Investing"],
                imageUrl: "https://media.istockphoto.com/id/1400960132/photo/light-bulb-is-located-on-soil-plants-grow-on-stacked-coins-renewable-energy-generation-is.jpg?s=612x612&w=0&k=20&c=BdJbzNurQMAsxkINA9dF1quvLNPK-zqA9FwOodTdbn8=",
                videoUrl: nil,
                hasVideo: false,
                indicators: Indicators(onHoldings: true, onSubscription: true, onWatchlist: false),
                category: "Investing",
                company: nil
            )
        ]
    }
    
    static var sampleFlagshipList: [Article] {
        [
            Article(
                id: "MIG001",
                title: "Monthly Investment Guide",
                hook: "Investment strategies for the current market...",
                description: "Comprehensive guide to investment opportunities...",
                date: "2025-09-05",
                tags: ["Investment", "Guide"],
                imageUrl: "https://media.istockphoto.com/id/1397011551/photo/stack-of-silver-coins-with-trading-chart-in-financial-concepts-and-financial-investment.jpg?s=612x612&w=0&k=20&c=spnvXHk8mNS7GAaz_Um16mllWjHa6oMrTwekQiR8qqU=",
                videoUrl: nil,
                hasVideo: false,
                indicators: nil,
                category: "MIG",
                company: nil
            ),
            Article(
                id: "CIO001",
                title: "CIO Weekly Update",
                hook: "Weekly insights from our Chief Investment Officer...",
                description: "Market analysis and investment strategy updates...",
                date: "2025-09-03",
                tags: ["CIO", "Weekly"],
                imageUrl: "https://media.istockphoto.com/id/1987166734/photo/meeting-whiteboard-and-senior-business-woman-in-boardroom-with-team-for-training-or-coaching.jpg?s=612x612&w=0&k=20&c=izeQTdEEjNAL6qN1cjWf1NExrAFBGttYOIRmwNDCQss=",
                videoUrl: nil,
                hasVideo: false,
                indicators: nil,
                category: "CIO Weekly",
                company: nil
            )
        ]
    }
    
    static var sampleStrategyList: [Article] {
        [
            Article(
                id: "SM001",
                title: "Global Macro Outlook",
                hook: "Macro trends this quarter...",
                description: "Extended analysis of global macroeconomic trends...",
                date: "2025-09-04",
                tags: ["Macroeconomics", "Strategy"],
                imageUrl: "https://media.istockphoto.com/id/1341853306/photo/hand-holding-virtual-world-with-copy-space-and-blue-bokeh-background-for-technology.jpg?s=612x612&w=0&k=20&c=DKWp5G5ArntF4meXBZgBA-z4rJykmZ6Y2qbi8gl-WLU=",
                videoUrl: nil,
                hasVideo: false,
                indicators: nil,
                category: "Strategy",
                company: nil
            ),
            Article(
                id: "FX001",
                title: "FX Market Outlook",
                hook: "Currency market trends and forecasts...",
                description: "Analysis of major currency pairs and trading strategies...",
                date: "2025-09-07",
                tags: ["Forex", "Trading"],
                imageUrl: "https://media.istockphoto.com/id/504246822/photo/forex-currency-trading-concept.jpg?s=612x612&w=0&k=20&c=CeTyIh5lRv_UvYKX-BbGMRRCl916JlnDRkYoQdf-oNM=",
                videoUrl: nil,
                hasVideo: false,
                indicators: nil,
                category: "FX",
                company: nil
            )
        ]
    }
    
    static var sampleCompanyReports: [Article] {
        [
            Article(
                id: "ER001",
                title: "Q3 Earnings Review",
                hook: "Highlights from Q3 earnings...",
                description: "Detailed analysis of Q3 financial performance...",
                date: "2025-09-06",
                tags: ["Earnings", "Analysis"],
                imageUrl: "https://media.istockphoto.com/id/1369763061/photo/quarterly-report-concept.jpg?s=612x612&w=0&k=20&c=tLmEtRTHFRKkKI-FbsgYKPqzDz-jfJ4oVAbcWahCL5g=",
                videoUrl: nil,
                hasVideo: false,
                indicators: nil,
                category: "Earnings",
                company: "Apple Inc."
            ),
            Article(
                id: "CR002",
                title: "Annual Report 2025",
                hook: "Comprehensive review of the fiscal year...",
                description: "Financial statements and business performance analysis...",
                date: "2025-09-08",
                tags: ["Annual Report", "Financials"],
                imageUrl: "https://media.istockphoto.com/id/174628030/photo/report.jpg?s=612x612&w=0&k=20&c=f5o6EaPA8cztWiZ7AIONax071B85ZZZJ5PYdcr6x1yA=",
                videoUrl: nil,
                hasVideo: false,
                indicators: nil,
                category: "Annual Report",
                company: "Microsoft Corp."
            )
        ]
    }
}
#endif
