import Foundation

struct Insight: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let date: Date
    let category: String
    
    init(id: UUID = UUID(), title: String, description: String, date: Date = Date(), category: String = "General") {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.category = category
    }
}

// MARK: - Sample Data
#if DEBUG
extension Insight {
    static let sampleData: [Insight] = [
        Insight(
            title: "Market Update",
            description: "Global markets show positive momentum with tech stocks leading the gains.",
            date: Date().addingTimeInterval(-3600),
            category: "Market"
        ),
        Insight(
            title: "Tech Trends",
            description: "AI and machine learning continue to drive innovation across industries.",
            date: Date().addingTimeInterval(-7200),
            category: "Technology"
        ),
        Insight(
            title: "Economic Outlook",
            description: "Experts predict steady growth in Q3 with potential interest rate adjustments.",
            date: Date().addingTimeInterval(-10800),
            category: "Economy"
        )
    ]
}
#endif
