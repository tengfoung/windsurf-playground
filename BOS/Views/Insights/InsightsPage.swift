import SwiftUI

struct InsightsPage: View {
    @StateObject private var viewModel = InsightsViewModel()
    @State private var showErrorAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                
                // Content
                ScrollView {
                    VStack(spacing: 24) {
                        // Show search results if searching
                        if viewModel.isSearching {
                            searchResultsView
                        } else {
                            // Regular content when not searching
                            regularContentView
                        }
                        
                        Spacer()
                    }
                    .padding(.bottom, 24)
                }
                .overlay(loadingOverlay)
                .padding(.top, -statusBarHeight-8)
            }
        }
        .onAppear {
            if !viewModel.isSearching && viewModel.topPicks.isEmpty {
                viewModel.fetchAllData()
            }
        }
    }
    
    // MARK: - Subviews
    
    private var searchResultsView: some View {
        Group {
            if viewModel.searchResults.isEmpty {
                if viewModel.isSearching {
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        
                        Text("No results found")
                            .font(.headline)
                        
                        if !viewModel.searchText.isEmpty {
                            Text("No matches for \"\(viewModel.searchText)\"")
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                }
            } else {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.searchResults) { article in
                        ArticleCard(article: article, isCompact: false)
                            .padding(.horizontal)
                    }
                }
            }
        }
    }
    
    private var regularContentView: some View {
        Group {
            // Top Picks Section
            if !viewModel.topPicks.isEmpty || !viewModel.moreTopPicks.isEmpty {
                TopPicksSection(
                    searchText: $viewModel.searchText,
                    isSearching: $viewModel.isSearching,
                    topPicks: viewModel.topPicks,
                    onViewAll: {},
                    onSearch: {
                        // Handle search submission if needed
                    }
                )
            }
            
            // Curated For You Section
            if !viewModel.curatedArticles.isEmpty {
                CuratedForYouSection(
                    articles: viewModel.curatedArticles,
                    onViewAll: {}
                )
            }
            
            // Flagship Publications Section
            if !viewModel.flagshipArticles.isEmpty {
                FlagshipPublicationsSection(
                    articles: viewModel.flagshipArticles,
                    onViewAll: {}
                )
            }
            
            // Strategy & Macroeconomics Section
            if !viewModel.strategyArticles.isEmpty {
                StrategyMacroSection(
                    articles: viewModel.strategyArticles,
                    onViewAll: {}
                )
            }
            
            // Company Reports Section
            if !viewModel.companyReports.isEmpty {
                CompanyReportsSection(
                    reports: viewModel.companyReports,
                    onViewAll: {}
                )
            }
        }
    }
    
    private var loadingOverlay: some View {
        Group {
            if viewModel.isLoading && !viewModel.isSearching {
                ZStack {
                    Color.black.opacity(0.2)
                        .edgesIgnoringSafeArea(.all)
                    
                    ProgressView("Loading...")
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemBackground))
                        )
                        .shadow(radius: 10)
                }
                .transition(.opacity)
            }
        }
    }
}

// MARK: - Previews

struct InsightsPage_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview with mock data
            InsightsPage()
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light Mode")
            
            InsightsPage()
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
