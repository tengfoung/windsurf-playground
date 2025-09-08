import Foundation
import Combine

@MainActor
class InsightsViewModel: ObservableObject {
    @Published var insights: [Insight] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service: NetworkingService
    private var cancellables = Set<AnyCancellable>()
    
    init(service: NetworkingService = MockNetworkingService()) {
        self.service = service
    }
    
    func fetchInsights() {
        isLoading = true
        errorMessage = nil
        
        service.fetchInsights { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let insights):
                    self.insights = insights
                case .failure(let error):
                    self.errorMessage = self.errorMessage(for: error)
                    #if DEBUG
                    self.insights = Insight.sampleData
                    #endif
                }
            }
        }
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
        }
    }
}
