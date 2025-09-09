import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case noData
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.noData, .noData),
             (.invalidResponse, .invalidResponse):
            return true
        case let (.requestFailed(error1), .requestFailed(error2)):
            return error1.localizedDescription == error2.localizedDescription
        case let (.decodingFailed(error1), .decodingFailed(error2)):
            return error1.localizedDescription == error2.localizedDescription
        default:
            return false
        }
    }
}

protocol NetworkingService {
    // Search
    func searchInsights(query: String, completion: @escaping (Result<[Insight], NetworkError>) -> Void)
    
    // Top Picks
    func fetchTopPicks(completion: @escaping (Result<[Insight], NetworkError>) -> Void)
    
    // Curated for You
    func fetchCuratedContent(completion: @escaping (Result<[Insight], NetworkError>) -> Void)
    
    // Flagship Publications
    func fetchFlagshipPublications(completion: @escaping (Result<[Insight], NetworkError>) -> Void)
    
    // Strategy & Macroeconomics
    func fetchStrategyAndMacro(completion: @escaping (Result<[Insight], NetworkError>) -> Void)
    
    // Company Reports
    func fetchCompanyReports(completion: @escaping (Result<[Insight], NetworkError>) -> Void)
}

// MARK: - Mock Implementation

class MockNetworkingService: NetworkingService {
    private let mockDelay: TimeInterval = 1.0
    
    func searchInsights(query: String, completion: @escaping (Result<[Insight], NetworkError>) -> Void) {
        simulateNetworkCall {
            completion(.success(Insight.sampleSearchResults))
        }
    }
    
    func fetchTopPicks(completion: @escaping (Result<[Insight], NetworkError>) -> Void) {
        simulateNetworkCall {
            completion(.success(Insight.sampleTopPicks))
        }
    }
    
    func fetchCuratedContent(completion: @escaping (Result<[Insight], NetworkError>) -> Void) {
        simulateNetworkCall {
            completion(.success(Insight.sampleCurated))
        }
    }
    
    func fetchFlagshipPublications(completion: @escaping (Result<[Insight], NetworkError>) -> Void) {
        simulateNetworkCall {
            completion(.success(Insight.sampleFlagship))
        }
    }
    
    func fetchStrategyAndMacro(completion: @escaping (Result<[Insight], NetworkError>) -> Void) {
        simulateNetworkCall {
            completion(.success(Insight.sampleStrategy))
        }
    }
    
    func fetchCompanyReports(completion: @escaping (Result<[Insight], NetworkError>) -> Void) {
        simulateNetworkCall {
            completion(.success(Insight.sampleCompanyReports))
        }
    }
    
    private func simulateNetworkCall(completion: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + mockDelay) {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}

// MARK: - Real Implementation

class RealNetworkingService: NetworkingService {
    private let baseURL = "https://api.example.com"
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.urlSession = session
        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.dateDecodingStrategy = .iso8601
    }
    
    // MARK: - API Methods
    
    func searchInsights(query: String, completion: @escaping (Result<[Insight], NetworkError>) -> Void) {
        let endpoint = "\(baseURL)/rest/search/globalSearchResults"
        var components = URLComponents(string: endpoint)
        components?.queryItems = [
            URLQueryItem(name: "query", value: query)
        ]
        
        guard let url = components?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        fetchData(from: url) { (result: Result<SearchResponse, NetworkError>) in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchTopPicks(completion: @escaping (Result<[Insight], NetworkError>) -> Void) {
        let endpoint = "\(baseURL)/rest/research/toppicks"
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        fetchData(from: url) { (result: Result<TopPicksResponse, NetworkError>) in
            switch result {
            case .success(let response):
                completion(.success(response.topPicks))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchCuratedContent(completion: @escaping (Result<[Insight], NetworkError>) -> Void) {
        let endpoint = "\(baseURL)/rest/research/myResearch"
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        fetchData(from: url) { (result: Result<CuratedResponse, NetworkError>) in
            switch result {
            case .success(let response):
                completion(.success(response.curated))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchFlagshipPublications(completion: @escaping (Result<[Insight], NetworkError>) -> Void) {
        let endpoint = "\(baseURL)/rest/research/periodical"
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        fetchData(from: url) { (result: Result<FlagshipResponse, NetworkError>) in
            switch result {
            case .success(let response):
                completion(.success(response.flagship))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchStrategyAndMacro(completion: @escaping (Result<[Insight], NetworkError>) -> Void) {
        let endpoint = "\(baseURL)/rest/research/strategyandmacroeconomocs"
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        fetchData(from: url) { (result: Result<StrategyResponse, NetworkError>) in
            switch result {
            case .success(let response):
                completion(.success(response.strategy))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchCompanyReports(completion: @escaping (Result<[Insight], NetworkError>) -> Void) {
        let endpoint = "\(baseURL)/rest/research/companyreport"
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        fetchData(from: url) { (result: Result<CompanyReportsResponse, NetworkError>) in
            switch result {
            case .success(let response):
                completion(.success(response.companyReports))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func fetchData<T: Decodable>(
        from url: URL,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.requestFailed(error)))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            guard let data = data, !data.isEmpty else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            do {
                let decodedData = try self.jsonDecoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingFailed(error)))
                }
            }
        }
        
        task.resume()
    }
}
