import Foundation
import Combine

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(endpoint: String) -> AnyPublisher<T, NetworkError>
    func searchArticles(query: String) -> AnyPublisher<[Article], NetworkError>
    func fetchTopPicks() -> AnyPublisher<[Article], NetworkError>
    func fetchCuratedForYou() -> AnyPublisher<[Article], NetworkError>
    func fetchFlagshipPublications() -> AnyPublisher<[Article], NetworkError>
    func fetchStrategyMacro() -> AnyPublisher<[Article], NetworkError>
    func fetchCompanyReports() -> AnyPublisher<[Article], NetworkError>
}
