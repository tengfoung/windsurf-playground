import Foundation
import Combine

@MainActor
class InsightsViewModel: ObservableObject {
    // MARK: - Published Properties
    
    // Search
    @Published var searchQuery: String = ""
    @Published var searchResults: [Insight] = []
    @Published var isSearching: Bool = false
    
    // Top Picks
    @Published var topPicks: [Insight] = []
    @Published var featuredTopPick: Insight?
    
    // Curated for You
    @Published var curatedContent: [Insight] = []
    
    // Flagship Publications
    @Published var flagshipPublications: [Insight] = []
    
    // Strategy & Macroeconomics
    @Published var strategyAndMacro: [Insight] = []
    
    // Company Reports
    @Published var companyReports: [Insight] = []
    
    // Loading & Error States
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var hasError: Bool = false
    
    // MARK: - Private Properties
    
    private let service: NetworkingService
    private var cancellables = Set<AnyCancellable>()
    private let debounceInterval: TimeInterval = 0.5
    
    // MARK: - Initialization
    
    init(service: NetworkingService = MockNetworkingService()) {
        self.service = service
        setupSearchDebounce()
    }
    
    // MARK: - Public Methods
    
    func fetchAllData() {
        isLoading = true
        hasError = false
        
        // Use a dispatch group to coordinate multiple async operations
        let group = DispatchGroup()
        
        // Fetch Top Picks
        group.enter()
        fetchTopPicks {
            group.leave()
        }
        
        // Fetch Curated Content
        group.enter()
        fetchCuratedContent {
            group.leave()
        }
        
        // Fetch Flagship Publications
        group.enter()
        fetchFlagshipPublications {
            group.leave()
        }
        
        // Fetch Strategy & Macroeconomics
        group.enter()
        fetchStrategyAndMacro {
            group.leave()
        }
        
        // Fetch Company Reports
        group.enter()
        fetchCompanyReports {
            group.leave()
        }
        
        // Notify when all requests are done
        group.notify(queue: .main) { [weak self] in
            self?.isLoading = false
        }
    }
    
    func refreshData() {
        fetchAllData()
    }
    
    // MARK: - Data Fetching Methods
    
    private func fetchTopPicks(completion: @escaping () -> Void) {
        service.fetchTopPicks { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let insights):
                    self?.topPicks = insights
                    self?.featuredTopPick = insights.first
                case .failure(let error):
                    self?.handleError(error)
                    #if DEBUG
                    self?.topPicks = Insight.sampleTopPicks
                    self?.featuredTopPick = Insight.sampleTopPicks.first
                    #endif
                }
                completion()
            }
        }
    }
    
    private func fetchCuratedContent(completion: @escaping () -> Void) {
        service.fetchCuratedContent { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let insights):
                    self?.curatedContent = Array(insights.prefix(5)) // Limit to 5 items for the carousel
                case .failure(let error):
                    self?.handleError(error)
                    #if DEBUG
                    self?.curatedContent = Array(Insight.sampleCurated.prefix(5))
                    #endif
                }
                completion()
            }
        }
    }
    
    private func fetchFlagshipPublications(completion: @escaping () -> Void) {
        service.fetchFlagshipPublications { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let insights):
                    self?.flagshipPublications = insights
                case .failure(let error):
                    self?.handleError(error)
                    #if DEBUG
                    self?.flagshipPublications = Insight.sampleFlagship
                    #endif
                }
                completion()
            }
        }
    }
    
    private func fetchStrategyAndMacro(completion: @escaping () -> Void) {
        service.fetchStrategyAndMacro { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let insights):
                    self?.strategyAndMacro = Array(insights.prefix(5)) // Limit to 5 items for the carousel
                case .failure(let error):
                    self?.handleError(error)
                    #if DEBUG
                    self?.strategyAndMacro = Array(Insight.sampleStrategy.prefix(5))
                    #endif
                }
                completion()
            }
        }
    }
    
    private func fetchCompanyReports(completion: @escaping () -> Void) {
        service.fetchCompanyReports { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let insights):
                    self?.companyReports = Array(insights.prefix(3)) // Show up to 3 latest reports
                case .failure(let error):
                    self?.handleError(error)
                    #if DEBUG
                    self?.companyReports = Array(Insight.sampleCompanyReports.prefix(3))
                    #endif
                }
                completion()
            }
        }
    }
    
    func performSearch(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        isSearching = true
        
        service.searchInsights(query: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.isSearching = false
                
                switch result {
                case .success(let results):
                    self?.searchResults = results
                case .failure(let error):
                    self?.handleError(error)
                    #if DEBUG
                    self?.searchResults = Insight.sampleSearchResults
                    #endif
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func setupSearchDebounce() {
        $searchQuery
            .debounce(for: .seconds(debounceInterval), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    private func handleError(_ error: NetworkError) {
        hasError = true
        errorMessage = errorMessage(for: error)
        print("Network Error: \(errorMessage ?? "Unknown error")")
    }
    
    private func errorMessage(for error: NetworkError) -> String {
        switch error {
        case .invalidURL:
            return "Invalid URL. Please check the API endpoint."
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        case .invalidResponse:
            return "Received an invalid response from the server."
        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .noData:
            return "No data received from the server."
        }
    }
    
    // MARK: - Helper Methods
    
    func getMoreTopPicks() -> [Insight] {
        // Return all top picks except the first one (featured)
        return Array(topPicks.dropFirst())
    }
    
    func getFeaturedFlagship() -> Insight? {
        // Get one article from each category if available
        return flagshipPublications.first
    }
}
