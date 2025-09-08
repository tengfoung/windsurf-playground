import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
}

protocol NetworkingService {
    func fetchInsights(completion: @escaping (Result<[Insight], NetworkError>) -> Void)
}

class MockNetworkingService: NetworkingService {
    private let mockDelay: TimeInterval = 1.0
    
    func fetchInsights(completion: @escaping (Result<[Insight], NetworkError>) -> Void) {
        // Simulate network delay
        DispatchQueue.global().asyncAfter(deadline: .now() + mockDelay) {
            // In a real app, this would be a network request
            // For now, we'll return mock data
            let mockInsights = Insight.sampleData
            DispatchQueue.main.async {
                completion(.success(mockInsights))
            }
        }
    }
}

class RealNetworkingService: NetworkingService {
    private let baseURL = "https://api.example.com"
    
    func fetchInsights(completion: @escaping (Result<[Insight], NetworkError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/insights") else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.success([]))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let insights = try decoder.decode([Insight].self, from: data)
                completion(.success(insights))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }.resume()
    }
}
