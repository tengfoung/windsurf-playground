import Foundation
import Combine

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        }
    }
}

class InsightsService: NetworkServiceProtocol {
    private let baseURL = "https://api.example.com"
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    init(urlSession: URLSession = .shared, jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        self.jsonDecoder.dateDecodingStrategy = .iso8601
    }
    
    // MARK: - Generic Network Request
    
    func fetch<T: Decodable>(endpoint: String) -> AnyPublisher<T, NetworkError> {
        guard let url = URL(string: baseURL + endpoint) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        return urlSession.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: jsonDecoder)
            .mapError { error -> NetworkError in
                if let networkError = error as? NetworkError {
                    return networkError
                } else if let _ = error as? DecodingError {
                    return .decodingFailed(error)
                } else {
                    return .requestFailed(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Search
    
    func searchArticles(query: String) -> AnyPublisher<[Article], NetworkError> {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let endpoint = "/rest/search/globalSearchResults?query=\(encodedQuery)"
        
        return fetch(endpoint: endpoint)
            .map { (response: SearchResponse) in
                return response.results
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Top Picks
    
    func fetchTopPicks() -> AnyPublisher<[Article], NetworkError> {
        return fetch(endpoint: "/rest/research/toppicks")
            .map { (response: TopPicksResponse) in
                return response.topPicks
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Curated For You
    
    func fetchCuratedForYou() -> AnyPublisher<[Article], NetworkError> {
        return fetch(endpoint: "/rest/research/myResearch")
            .map { (response: CuratedResponse) in
                return response.curated
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Flagship Publications
    
    func fetchFlagshipPublications() -> AnyPublisher<[Article], NetworkError> {
        return fetch(endpoint: "/rest/research/periodical")
            .map { (response: FlagshipResponse) in
                return response.flagship
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Strategy & Macroeconomics
    
    func fetchStrategyMacro() -> AnyPublisher<[Article], NetworkError> {
        return fetch(endpoint: "/rest/research/strategyandmacroeconomocs")
            .map { (response: StrategyResponse) in
                return response.strategy
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Company Reports
    
    func fetchCompanyReports() -> AnyPublisher<[Article], NetworkError> {
        return fetch(endpoint: "/rest/research/companyreport")
            .map { (response: CompanyReportsResponse) in
                return response.companyReports
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Mock Service for Previews

class MockInsightsService: NetworkServiceProtocol {
    func fetch<T>(endpoint: String) -> AnyPublisher<T, NetworkError> where T : Decodable {
        // This is a simplified mock - in a real app, you'd return mock data here
        return Empty().eraseToAnyPublisher()
    }
    
    func searchArticles(query: String) -> AnyPublisher<[Article], NetworkError> {
        // Return mock search results
        let mockArticle = Article.mock
        return Just([mockArticle])
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func fetchTopPicks() -> AnyPublisher<[Article], NetworkError> {
        // Return mock top picks
        let mockArticle = Article.mockWithVideo
        return Just([mockArticle])
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func fetchCuratedForYou() -> AnyPublisher<[Article], NetworkError> {
        // Return mock curated articles
        let mockArticle = Article.mock
        return Just(Array(repeating: mockArticle, count: 5))
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func fetchFlagshipPublications() -> AnyPublisher<[Article], NetworkError> {
        // Return mock flagship publications
        var migArticle = Article.mock
        migArticle.category = "MIG"
        migArticle.title = "Monthly Investment Guide"
        
        var cioArticle = Article.mock
        cioArticle.category = "CIO Weekly"
        cioArticle.title = "Weekly CIO Update"
        
        return Just([migArticle, cioArticle])
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func fetchStrategyMacro() -> AnyPublisher<[Article], NetworkError> {
        // Return mock strategy articles
        let mockArticle = Article.mock
        return Just(Array(repeating: mockArticle, count: 5))
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func fetchCompanyReports() -> AnyPublisher<[Article], NetworkError> {
        // Return mock company reports
        var report = Article.mock
        report.company = "Apple Inc."
        report.title = "Q3 Earnings Review"
        
        return Just(Array(repeating: report, count: 3))
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
}
