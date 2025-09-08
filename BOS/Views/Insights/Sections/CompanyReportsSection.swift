import SwiftUI

struct CompanyReportsSection: View {
    let reports: [Article]
    let onViewAll: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeaderView(
                title: "Company Reports"
            )
            
            if !reports.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(reports) { report in
                            VStack(alignment: .leading, spacing: 8) {
                                if let company = report.company {
                                    Text(company)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                }
                                
                                ArticleCard(article: report, isCompact: true)
                                    .frame(width: 300)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                Text("No company reports available")
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Previews

struct CompanyReportsSection_Previews: PreviewProvider {
    static var previews: some View {
        let mockReport = Article(
            id: "CR001",
            title: "Q3 Earnings Review",
            hook: "Strong performance in Q3 with revenue growth of 12%",
            description: "Detailed analysis of Q3 financial results, including revenue breakdown, profit margins, and forward guidance.",
            date: "2025-09-01",
            imageUrl: nil,
            videoUrl: nil,
            category: "Earnings Report",
            company: "Apple Inc.",
            type: "report",
            tags: [
                Tag(id: "1", name: "Earnings", type: "report"),
                Tag(id: "2", name: "Technology", type: "sector")
            ],
            indicators: nil
        )
        
        return CompanyReportsSection(
            reports: [mockReport, mockReport, mockReport],
            onViewAll: {}
        )
        .previewLayout(.sizeThatFits)
    }
}
