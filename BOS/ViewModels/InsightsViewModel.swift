import Foundation
import Combine

@MainActor
final class InsightsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var searchQuery: String = ""
    @Published var searchResults: [Article] = []
    @Published var topPicks: [Article] = []
    @Published var curated: [Article] = []
    @Published var flagship: [Article] = []
    @Published var strategy: [Article] = []
    @Published var companyReports: [Article] = []
    
    // Loading states
    @Published var isLoading = false
    @Published var isSearching = false
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    private let service: NetworkingService
    private var searchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(service: NetworkingService = MockNetworkingService()) {
        self.service = service
        setupSearch()
    }
    
    // MARK: - Public Methods
    func fetchAllData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Fetch all data in parallel
            async let topPicksTask = service.fetchTopPicks()
            async let curatedTask = service.fetchCurated()
            async let flagshipTask = service.fetchFlagshipPublications()
            async let strategyTask = service.fetchStrategyAndMacro()
            async let companyReportsTask = service.fetchCompanyReports()
            
            // Await all tasks
            let results = await (try? (
                topPicks: topPicksTask,
                curated: curatedTask,
                flagship: flagshipTask,
                strategy: strategyTask,
                companyReports: companyReportsTask
            ))
            
            // Update UI on main thread
            await MainActor.run {
                if let results = results {
                    self.topPicks = results.topPicks
                    self.curated = Array(results.curated.prefix(5)) // Limit to 5 items
                    self.flagship = results.flagship
                    self.strategy = Array(results.strategy.prefix(5)) // Limit to 5 items
                    self.companyReports = Array(results.companyReports.prefix(3)) // Limit to 3 items
                } else {
                    // If any request failed, set default empty arrays to avoid showing stale data
                    self.topPicks = []
                    self.curated = []
                    self.flagship = []
                    self.strategy = []
                    self.companyReports = []
                    
                    #if DEBUG
                    // In debug mode, use sample data if available
                    self.topPicks = Article.sampleTopPicks
                    self.curated = Article.sampleCuratedList
                    self.flagship = Article.sampleFlagshipList
                    self.strategy = Article.sampleStrategyList
                    self.companyReports = Article.sampleCompanyReports
                    #endif
                }
                
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Search
    private func setupSearch() {
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(query: String) {
        searchTask?.cancel()
        
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            searchResults = []
            isSearching = false
            return
        }
        
        isSearching = true
        
        searchTask = Task {
            do {
                let results = try await service.searchInsights(query: query)
                if !Task.isCancelled {
                    await MainActor.run {
                        self.searchResults = results
                        self.isSearching = false
                    }
                }
            } catch {
                if !Task.isCancelled {
                    await MainActor.run {
                        self.errorMessage = "Search failed: \(error.localizedDescription)"
                        self.isSearching = false
                    }
                }
            }
        }
    }
    
    // MARK: - Error Handling
    func clearError() {
        errorMessage = nil
    }
    
    // MARK: - Helper Methods
    func refreshData() async {
        await fetchAllData()
    }
    
    // MARK: - Preview Support
    #if DEBUG
    static var preview: InsightsViewModel {
        let viewModel = InsightsViewModel(service: MockNetworkingService())
        viewModel.topPicks = Article.sampleTopPicks
        viewModel.curated = Article.sampleCuratedList
        viewModel.flagship = Article.sampleFlagshipList
        viewModel.strategy = Article.sampleStrategyList
        viewModel.companyReports = Article.sampleCompanyReports
        return viewModel
    }
    #endif
}
