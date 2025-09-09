import SwiftUI

struct InsightsView: View {
    @StateObject private var viewModel = InsightsViewModel()
    @State private var showSearchResults = false
    @State private var selectedArticle: Article?
    @State private var showArticleDetail = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background color that works in both light/dark mode
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                
                // Main content
                Group {
                    if viewModel.isLoading && viewModel.topPicks.isEmpty {
                        loadingView
                    } else if let errorMessage = viewModel.errorMessage {
                        errorView(message: errorMessage)
                    } else {
                        contentView
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Insights")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                }
                .onAppear {
                    Task {
                        await viewModel.fetchAllData()
                    }
                }
                .refreshable {
                    await viewModel.refreshData()
                }
                .onChange(of: viewModel.searchQuery) { newValue in
                    withAnimation {
                        showSearchResults = !newValue.isEmpty
                    }
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView("Loading insights...")
                .progressViewStyle(CircularProgressViewStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.orange)
            
            Text("Error Loading Data")
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Retry") {
                Task {
                    await viewModel.fetchAllData()
                }
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    private var contentView: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(
                    text: $viewModel.searchQuery,
                    isSearching: $viewModel.isSearching
                )
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
                
                // Show search results or regular content
                if showSearchResults {
                    searchResultsView
                } else {
                    regularContentView
                }
                
                Spacer(minLength: 16)
            }
        }
        .background(Color(.systemGroupedBackground))
    }
    
    private var searchResultsView: some View {
        Group {
            if viewModel.isSearching {
                HStack {
                    Spacer()
                    ProgressView()
                        .padding()
                    Spacer()
                }
            } else if viewModel.searchResults.isEmpty {
                emptyStateView(
                    title: "No Results",
                    message: "No articles found for '\(viewModel.searchQuery)'"
                )
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.searchResults) { article in
                        Button(action: {
                            selectedArticle = article
                            showArticleDetail = true
                        }) {
                            ArticleCardView(
                                article: article,
                                showIndicators: true,
                                imageHeight: 180
                            )
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Divider()
                            .padding(.leading)
                    }
                }
                .background(Color(.systemBackground))
            }
        }
    }
    
    private var regularContentView: some View {
        VStack(spacing: 0) {
            // Top Picks Section
            if !viewModel.topPicks.isEmpty {
                TopPicksSection(
                    topPicks: viewModel.topPicks,
                    onSeeAll: { /* Handle see all top picks */ }
                )
                //.background(Color(.systemBackground))
                .padding(.top, 8)
            }
            
            Divider()
            
            // Curated For You Section
            if !viewModel.curated.isEmpty {
                CuratedForYouSection(
                    articles: viewModel.curated,
                    onSeeAll: { /* Handle see all curated */ }
                )
                //.background(Color(.systemBackground))
                .padding(.vertical, 8)
            }
            
            Divider()
            
            // Flagship Publications Section
            if !viewModel.flagship.isEmpty {
                FlagshipPublicationsSection(
                    articles: viewModel.flagship,
                    onSeeAll: { /* Handle see all flagship */ }
                )
                //.background(Color(.systemBackground))
                .padding(.vertical, 8)
            }
            
            Divider()
            
            // Strategy & Macroeconomics Section
            if !viewModel.strategy.isEmpty {
                StrategyMacroSection(
                    articles: viewModel.strategy,
                    onSeeAll: { /* Handle see all strategy */ }
                )
                //.background(Color(.systemBackground))
                .padding(.vertical, 8)
            }
            
            Divider()
            
            // Company Reports Section
            if !viewModel.companyReports.isEmpty {
                CompanyReportsSection(
                    reports: viewModel.companyReports,
                    onSeeAll: { /* Handle see all company reports */ }
                )
                //.background(Color(.systemBackground))
                .padding(.vertical, 8)
            }
        }
    }
    
    private func emptyStateView(title: String, message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text(title)
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, minHeight: 300)
        .background(Color(.systemBackground))
        .padding(.top, 32)
    }
}

// MARK: - Preview
struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview with sample data
            InsightsView()
                .environmentObject(InsightsViewModel.preview)
                .previewDisplayName("Sample Data")
            
            // Preview dark mode
            InsightsView()
                .environmentObject(InsightsViewModel.preview)
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
            
            // Preview loading state
            LoadingPreview()
                .previewDisplayName("Loading State")
            
            // Preview error state
            ErrorPreview()
                .previewDisplayName("Error State")
        }
    }
    
    // Helper subviews to keep each Group child a single expression
    private struct LoadingPreview: View {
        @StateObject private var vm: InsightsViewModel
        init() {
            let temp = InsightsViewModel()
            temp.isLoading = true
            _vm = StateObject(wrappedValue: temp)
        }
        var body: some View {
            InsightsView()
                .environmentObject(vm)
        }
    }
    
    private struct ErrorPreview: View {
        @StateObject private var vm: InsightsViewModel
        init() {
            let temp = InsightsViewModel()
            temp.errorMessage = "Failed to load data. Please check your connection and try again."
            _vm = StateObject(wrappedValue: temp)
        }
        var body: some View {
            InsightsView()
                .environmentObject(vm)
        }
    }
}
