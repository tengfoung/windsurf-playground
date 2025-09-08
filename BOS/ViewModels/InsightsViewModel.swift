import Foundation
import Combine

@MainActor
class InsightsViewModel: ObservableObject {
    // MARK: - Published Properties
    
    // Search
    @Published var searchText = ""
    @Published var searchResults: [Article] = []
    @Published var isSearching = false
    @Published var searchError: String?
    
    // Top Picks
    @Published var topPicks: [Article] = []
    @Published var moreTopPicks: [Article] = []
    
    // Curated For You
    @Published var curatedArticles: [Article] = []
    
    // Flagship Publications
    @Published var flagshipArticles: [Article] = []
    
    // Strategy & Macroeconomics
    @Published var strategyArticles: [Article] = []
    
    // Company Reports
    @Published var companyReports: [Article] = []
    
    // Loading & Error States
    @Published var isLoading = false
    @Published var error: Error?
    @Published var showError = false
    
    // MARK: - Private Properties
    
    private let networkService: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var searchCancellable: AnyCancellable?
    
    // MARK: - Initialization
    
    init(networkService: NetworkServiceProtocol = InsightsService()) {
        self.networkService = networkService
        setupSearch()
    }
    
    // MARK: - Public Methods
    
    func fetchAllData() {
        isLoading = true
        error = nil
        
        // Create publishers for all API calls, applying side effects in handleEvents
        let topPicksPublisher = networkService.fetchTopPicks()
            .handleEvents(receiveOutput: { [weak self] articles in
                self?.processTopPicks(articles)
            })
            .map { _ in () }
            .eraseToAnyPublisher()
        
        let curatedPublisher = networkService.fetchCuratedForYou()
            .handleEvents(receiveOutput: { [weak self] articles in
                self?.curatedArticles = Array(articles.prefix(5))
            })
            .map { _ in () }
            .eraseToAnyPublisher()
        
        let flagshipPublisher = networkService.fetchFlagshipPublications()
            .handleEvents(receiveOutput: { [weak self] articles in
                self?.flagshipArticles = articles
            })
            .map { _ in () }
            .eraseToAnyPublisher()
        
        let strategyPublisher = networkService.fetchStrategyMacro()
            .handleEvents(receiveOutput: { [weak self] articles in
                self?.strategyArticles = Array(articles.prefix(5))
            })
            .map { _ in () }
            .eraseToAnyPublisher()
        
        let companyReportsPublisher = networkService.fetchCompanyReports()
            .handleEvents(receiveOutput: { [weak self] reports in
                self?.companyReports = Array(reports.prefix(3))
            })
            .map { _ in () }
            .eraseToAnyPublisher()
        
        // Merge all publishers and wait for all to finish
        Publishers.MergeMany([
            topPicksPublisher,
            curatedPublisher,
            flagshipPublisher,
            strategyPublisher,
            companyReportsPublisher
        ])
        .collect() // waits for all to complete successfully
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                if case .failure(let error) = completion {
                    self.error = error
                    self.showError = true
                    #if DEBUG
                    // In debug mode, load mock data on error
                    self.loadMockData()
                    #endif
                }
            },
            receiveValue: { _ in }
        )
        .store(in: &cancellables)
    }
    
    // MARK: - Search
    
    private func setupSearch() {
        searchCancellable = $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
    }
    
    private func performSearch(query: String) {
        isSearching = true
        searchError = nil
        
        networkService.searchArticles(query: query)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isSearching = false
                    if case .failure(let error) = completion {
                        self?.searchError = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] results in
                    self?.searchResults = results
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Helper Methods
    
    private func processTopPicks(_ articles: [Article]) {
        guard !articles.isEmpty else {
            topPicks = []
            moreTopPicks = []
            return
        }
        
        // First article is today's top pick, rest are more top picks
        topPicks = [articles[0]]
        moreTopPicks = Array(articles.dropFirst().prefix(4))
    }
    
    // MARK: - Mock Data for Previews
    
    #if DEBUG
    private func loadMockData() {
        // For preview and debugging purposes
        let mockArticle = Article.mock
        let mockArticleWithVideo = Article.mockWithVideo
        
        // Top Picks
        topPicks = [mockArticle]
        moreTopPicks = Array(repeating: mockArticleWithVideo, count: 3)
        
        // Curated
        curatedArticles = Array(repeating: mockArticle, count: 5)
        
        // Flagship
        var migArticle = mockArticle
        migArticle.category = "MIG"
        migArticle.title = "Monthly Investment Guide"
        
        var cioArticle = mockArticleWithVideo
        cioArticle.category = "CIO Weekly"
        cioArticle.title = "Weekly CIO Update"
        
        flagshipArticles = [migArticle, cioArticle]
        
        // Strategy
        strategyArticles = Array(repeating: mockArticle, count: 5)
        
        // Company Reports
        var report = mockArticle
        report.company = "Apple Inc."
        report.title = "Q3 Earnings Review"
        companyReports = Array(repeating: report, count: 3)
    }
    #endif
}
