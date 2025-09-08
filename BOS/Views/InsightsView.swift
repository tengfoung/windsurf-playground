import SwiftUI

struct InsightsView: View {
    @StateObject private var viewModel = InsightsViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Top Picks Section
                    if !viewModel.topPicks.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeaderView(title: "Top picks")
                            
                            VStack(spacing: 12) {
                                ForEach(viewModel.topPicks) { article in
                                    ArticleCard(article: article, isCompact: false)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // More Top Picks Section
                    if !viewModel.moreTopPicks.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeaderView(title: "Editor's picks")
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(viewModel.moreTopPicks) { article in
                                        ArticleCard(article: article, isCompact: true)
                                            .frame(width: 280)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Curated For You Section
                    if !viewModel.curatedArticles.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeaderView(title: "Curated for you")
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(viewModel.curatedArticles) { article in
                                        ArticleCard(article: article, isCompact: true)
                                            .frame(width: 280)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Flagship Publications Section
                    if !viewModel.flagshipArticles.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeaderView(title: "Flagship publications")
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(viewModel.flagshipArticles) { article in
                                        ArticleCard(article: article, isCompact: true)
                                            .frame(width: 280)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Strategy & Macroeconomics Section
                    if !viewModel.strategyArticles.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeaderView(title: "Strategy & Macroeconomics")
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(viewModel.strategyArticles) { article in
                                        ArticleCard(article: article, isCompact: true)
                                            .frame(width: 280)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Company Reports Section
                    if !viewModel.companyReports.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeaderView(title: "Company reports")
                            
                            VStack(spacing: 16) {
                                ForEach(viewModel.companyReports) { report in
                                    HStack(alignment: .top, spacing: 12) {
                                        // Company logo or placeholder
                                        Circle()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(width: 40, height: 40)
                                            .overlay(
                                                Text((report.company?.prefix(2) ?? "CO"))
                                                    .font(.headline)
                                                    .foregroundColor(.primary)
                                            )
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(report.company ?? "Company")
                                                .font(.headline)
                                            
                                            Text(report.title)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                                .lineLimit(2)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.secondary)
                                    }
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(12)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Loading state
                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                    }
                    
                    // Error state
                    if let error = viewModel.error {
                        VStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.title)
                                .foregroundColor(.orange)
                            
                            Text("Failed to load content")
                                .font(.headline)
                            
                            Text(error.localizedDescription)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            Button("Retry") {
                                viewModel.fetchAllData()
                            }
                            .buttonStyle(.bordered)
                            .padding(.top, 8)
                        }
                        .padding()
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Insights")
            .background(Color(.systemGroupedBackground))
            .refreshable {
                viewModel.fetchAllData()
            }
        }
        .onAppear {
            if viewModel.topPicks.isEmpty && viewModel.moreTopPicks.isEmpty {
                viewModel.fetchAllData()
            }
        }
    }
}

// MARK: - Section Header View

struct SectionHeaderView: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
            
            Spacer()
            
            Button("See all") {
                // Action for see all
            }
            .font(.subheadline)
            .foregroundColor(.blue)
            .padding(.horizontal)
        }
    }
}

// MARK: - Preview

struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        //viewModel.loadMockData()
        return InsightsView()
    }
}

// MARK: - Extensions

extension View {
    func sectionHeader() -> some View {
        self
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
}
