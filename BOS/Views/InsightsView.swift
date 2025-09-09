import SwiftUI

struct InsightsView: View {
    @StateObject private var viewModel = InsightsViewModel()
    @State private var searchText = ""
    @State private var showSearchResults = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Main content
                ScrollView {
                    VStack(spacing: 24) {
                        // Search Bar
                        SearchBar(text: $searchText, onSearch: { query in
                            viewModel.performSearch(query: query)
                            showSearchResults = !query.isEmpty
                        })
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        if showSearchResults {
                            SearchResultsView(viewModel: viewModel, showSearchResults: $showSearchResults)
                        } else {
                            // Main Content
                            VStack(spacing: 32) {
                                // Top Picks Section
                                TopPicksSection(viewModel: viewModel)
                                
                                // Curated for You Section
                                CuratedSection(viewModel: viewModel)
                                
                                // Flagship Publications Section
                                FlagshipSection(viewModel: viewModel)
                                
                                // Strategy & Macroeconomics Section
                                StrategySection(viewModel: viewModel)
                                
                                // Company Reports Section
                                CompanyReportsSection(viewModel: viewModel)
                                
                                Spacer()
                                    .frame(height: 20)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 20)
                }
                .background(Color(.systemGroupedBackground))
                .onAppear {
                    viewModel.fetchAllData()
                }
                .refreshable {
                    viewModel.refreshData()
                }
                
                // Loading and Error States
                if viewModel.isLoading && viewModel.topPicks.isEmpty {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemBackground).opacity(0.8))
                }
                
                if viewModel.hasError, let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text("Error Loading Data")
                            .font(.headline)
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button("Retry") {
                            viewModel.refreshData()
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Insights")
                        .font(.headline)
                }
            }
        }
    }
}

// MARK: - Search Components

struct SearchBar: View {
    @Binding var text: String
    var onSearch: (String) -> Void
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search for insights...", text: $text) { isEditing in
                    self.isEditing = isEditing
                } onCommit: {
                    onSearch(text)
                }
                .autocapitalization(.none)
                .disableAutocorrection(true)
                
                if !text.isEmpty {
                    Button(action: {
                        self.text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            if isEditing {
                Button("Cancel") {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    self.isEditing = false
                    self.text = ""
                }
                .foregroundColor(.blue)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}

struct SearchResultsView: View {
    @ObservedObject var viewModel: InsightsViewModel
    @Binding var showSearchResults: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Search Results")
                    .font(.headline)
                Spacer()
                Button(action: {
                    showSearchResults = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            if viewModel.isSearching {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding()
            } else if viewModel.searchResults.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    Text("No results found")
                        .font(.headline)
                    Text("Try different keywords")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.searchResults) { result in
                        InsightRow(insight: result)
                            .padding(.vertical, 8)
                        
                        if result.id != viewModel.searchResults.last?.id {
                            Divider()
                        }
                    }
                }
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Section Views

struct TopPicksSection: View {
    @ObservedObject var viewModel: InsightsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Top Picks", showViewAll: true) {
                // Navigate to full Top Picks list
            }
            
            if let featured = viewModel.featuredTopPick {
                FeaturedTopPickView(insight: featured)
            }
            
            if !viewModel.getMoreTopPicks().isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.getMoreTopPicks()) { insight in
                            TopPickCard(insight: insight)
                                .frame(width: 240)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal, -16)
            }
        }
    }
}

struct CuratedSection: View {
    @ObservedObject var viewModel: InsightsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Curated for You", showViewAll: true) {
                // Navigate to full Curated list
            }
            
            if !viewModel.curatedContent.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.curatedContent) { insight in
                            CuratedCard(insight: insight)
                                .frame(width: 200)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal, -16)
            }
        }
    }
}

struct FlagshipSection: View {
    @ObservedObject var viewModel: InsightsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Flagship Publications", showViewAll: true) {
                // Navigate to full Flagship list
            }
            
            if !viewModel.flagshipPublications.isEmpty {
                VStack(spacing: 12) {
                    ForEach(viewModel.flagshipPublications.prefix(4)) { insight in
                        FlagshipRow(insight: insight)
                        
                        if insight.id != viewModel.flagshipPublications.prefix(4).last?.id {
                            Divider()
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
            }
        }
    }
}

struct StrategySection: View {
    @ObservedObject var viewModel: InsightsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Strategy & Macroeconomics", showViewAll: true) {
                // Navigate to full Strategy list
            }
            
            if !viewModel.strategyAndMacro.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.strategyAndMacro) { insight in
                            StrategyCard(insight: insight)
                                .frame(width: 260)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal, -16)
            }
        }
    }
}

struct CompanyReportsSection: View {
    @ObservedObject var viewModel: InsightsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Company Reports", showViewAll: true) {
                // Navigate to full Company Reports list
            }
            
            if !viewModel.companyReports.isEmpty {
                VStack(spacing: 12) {
                    ForEach(viewModel.companyReports) { report in
                        CompanyReportRow(report: report)
                        
                        if report.id != viewModel.companyReports.last?.id {
                            Divider()
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
            }
        }
    }
}

// MARK: - Card Components

struct InsightRow: View {
    let insight: Insight
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let imageUrl = insight.imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 160)
                        .clipped()
                } placeholder: {
                    Color(.systemGray6)
                        .frame(height: 160)
                }
                .cornerRadius(8)
                .padding(.bottom, 8)
            }
            
            Text(insight.title)
                .font(.headline)
                .lineLimit(2)
            
            if !insight.hook.isEmpty {
                Text(insight.hook)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            HStack {
                if let date = ISO8601DateFormatter().date(from: insight.date) {
                    Text(date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if let hasVideo = insight.hasVideo, hasVideo {
                    Image(systemName: "play.circle.fill")
                        .foregroundColor(.blue)
                }
                
                Button(action: {
                    // Share action
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.gray)
                }
            }
            .padding(.top, 4)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

struct FeaturedTopPickView: View {
    let insight: Insight
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let imageUrl = insight.imageUrl, let url = URL(string: imageUrl) {
                ZStack(alignment: .bottomLeading) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                    } placeholder: {
                        Color(.systemGray6)
                            .frame(height: 200)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("TODAY'S TOP PICK")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue)
                            .cornerRadius(4)
                        
                        Text(insight.title)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                            .lineLimit(2)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(insight.hook)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    if let date = ISO8601DateFormatter().date(from: insight.date) {
                        Text(date, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if let hasVideo = insight.hasVideo, hasVideo {
                        HStack(spacing: 4) {
                            Image(systemName: "play.circle.fill")
                                .foregroundColor(.blue)
                            Text("Watch")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .padding(.horizontal, 4)
        }
    }
}

struct TopPickCard: View {
    let insight: Insight
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let imageUrl = insight.imageUrl, let url = URL(string: imageUrl) {
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 120)
                            .clipped()
                    } placeholder: {
                        Color(.systemGray6)
                            .frame(height: 120)
                    }
                    
                    if let hasVideo = insight.hasVideo, hasVideo {
                        Image(systemName: "play.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(8)
                            .shadow(radius: 3)
                    }
                }
                .cornerRadius(8)
            }
            
            Text(insight.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(2)
            
            if let date = ISO8601DateFormatter().date(from: insight.date) {
                Text(date, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct CuratedCard: View {
    let insight: Insight
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let imageUrl = insight.imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 100)
                        .clipped()
                } placeholder: {
                    Color(.systemGray6)
                        .frame(height: 100)
                }
                .cornerRadius(8)
            }
            
            Text(insight.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(2)
            
            HStack {
                if let date = ISO8601DateFormatter().date(from: insight.date) {
                    Text(date, style: .date)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if let indicators = insight.indicators {
                    HStack(spacing: 4) {
                        if indicators.onHoldings {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.caption2)
                        }
                        
                        if indicators.onWatchlist {
                            Image(systemName: "bookmark.fill")
                                .foregroundColor(.blue)
                                .font(.caption2)
                        }
                    }
                }
            }
        }
    }
}

struct FlagshipRow: View {
    let insight: Insight
    
    var body: some View {
        HStack(spacing: 12) {
            if let imageUrl = insight.imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipped()
                        .cornerRadius(8)
                } placeholder: {
                    Color(.systemGray6)
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                if let category = insight.category {
                    Text(category.uppercased())
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                
                Text(insight.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                
                if let date = ISO8601DateFormatter().date(from: insight.date) {
                    Text(date, style: .date)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
}

struct StrategyCard: View {
    let insight: Insight
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let imageUrl = insight.imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()
                } placeholder: {
                    Color(.systemGray6)
                        .frame(height: 120)
                }
                .cornerRadius(8)
            }
            
            Text(insight.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(2)
            
            Text(insight.hook)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            if let date = ISO8601DateFormatter().date(from: insight.date) {
                Text(date, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct CompanyReportRow: View {
    let report: Insight
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                if let company = report.company {
                    Text(company.uppercased())
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                
                Text(report.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                
                if let date = ISO8601DateFormatter().date(from: report.date) {
                    Text(date, style: .date)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Button(action: {
                // Share action
            }) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.blue)
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
            }
        }
    }
}

// MARK: - Reusable Components

struct SectionHeader: View {
    let title: String
    let showViewAll: Bool
    var action: () -> Void = {}
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            
            Spacer()
            
            if showViewAll {
                Button(action: action) {
                    HStack(spacing: 4) {
                        Text("View all")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        
                        Image(systemName: "chevron.right")
                            .font(.caption2)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

// MARK: - Preview

struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView()
            .preferredColorScheme(.light)
        
        InsightsView()
            .preferredColorScheme(.dark)
    }
}

// MARK: - Preview Helpers

#if DEBUG
extension View {
    func previewAllColorSchemes() -> some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            self
                .preferredColorScheme(scheme)
                .previewDisplayName("\(scheme) mode")
        }
    }
}
#endif
