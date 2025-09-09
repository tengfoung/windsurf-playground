import Foundation
import Combine

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case noData
    
    var localizedDescription: String {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .requestFailed(let error): return "Request failed: \(error.localizedDescription)"
        case .invalidResponse: return "Invalid response from server"
        case .decodingFailed(let error): return "Failed to decode response: \(error.localizedDescription)"
        case .noData: return "No data received"
        }
    }
}

protocol NetworkingService {
    // Search
    func searchInsights(query: String) async throws -> [Article]
    
    // Top Picks
    func fetchTopPicks() async throws -> [Article]
    
    // Curated for You
    func fetchCurated() async throws -> [Article]
    
    // Flagship Publications
    func fetchFlagshipPublications() async throws -> [Article]
    
    // Strategy & Macroeconomics
    func fetchStrategyAndMacro() async throws -> [Article]
    
    // Company Reports
    func fetchCompanyReports() async throws -> [Article]
}

class MockNetworkingService: NetworkingService {
    private let mockDelay: TimeInterval = 0.5
    
    private func simulateNetworkCall<T>(_ result: T) async throws -> T {
        try await Task.sleep(nanoseconds: UInt64(mockDelay * 1_000_000_000))
        return result
    }
    
    func searchInsights(query: String) async throws -> [Article] {
        // In a real app, this would filter based on the query
        return try await simulateNetworkCall(Article.sampleTopPicks)
    }
    
    func fetchTopPicks() async throws -> [Article] {
        return try await simulateNetworkCall(Article.sampleTopPicks)
    }
    
    func fetchCurated() async throws -> [Article] {
        return try await simulateNetworkCall(Article.sampleCuratedList)
    }
    
    func fetchFlagshipPublications() async throws -> [Article] {
        return try await simulateNetworkCall(Article.sampleFlagshipList)
    }
    
    func fetchStrategyAndMacro() async throws -> [Article] {
        return try await simulateNetworkCall(Article.sampleStrategyList)
    }
    
    func fetchCompanyReports() async throws -> [Article] {
        return try await simulateNetworkCall(Article.sampleCompanyReports)
    }
}

class RealNetworkingService: NetworkingService {
    private let baseURL = "https://api.example.com/v1"
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    
    private func fetch<T: Decodable>(endpoint: String) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, 
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
    
    // MARK: - API Endpoints
    
    func searchInsights(query: String) async throws -> [Article] {
        let searchTerm = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let response: SearchResponse = try await fetch(endpoint: "/rest/search/globalSearchResults?query=\(searchTerm)")
        return response.results
    }
    
    func fetchTopPicks() async throws -> [Article] {
        let response: TopPicksResponse = try await fetch(endpoint: "/rest/research/toppicks")
        return response.topPicks
    }
    
    func fetchCurated() async throws -> [Article] {
        let response: CuratedResponse = try await fetch(endpoint: "/rest/research/myResearch")
        return response.curated
    }
    
    func fetchFlagshipPublications() async throws -> [Article] {
        let response: FlagshipResponse = try await fetch(endpoint: "/rest/research/periodical")
        return response.flagship
    }
    
    func fetchStrategyAndMacro() async throws -> [Article] {
        let response: StrategyResponse = try await fetch(endpoint: "/rest/research/strategyandmacroeconomocs")
        return response.strategy
    }
    
    func fetchCompanyReports() async throws -> [Article] {
        let response: CompanyReportsResponse = try await fetch(endpoint: "/rest/research/companyreport")
        return response.companyReports
    }
}
