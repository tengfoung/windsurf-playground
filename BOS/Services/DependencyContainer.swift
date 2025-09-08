import Foundation
import SwiftUI

class DependencyContainer {
    // Shared instance for dependency injection
    static let shared = DependencyContainer()
    
    // Services
    private(set) var networkingService: NetworkingService
    
    private init() {
        // In a real app, you might want to switch between mock and real services based on build configuration
        #if DEBUG
        self.networkingService = MockNetworkingService()
        #else
        self.networkingService = RealNetworkingService()
        #endif
    }
    
    // MARK: - View Models
    
    @MainActor
    func makeInsightsViewModel() -> InsightsViewModel {
        return InsightsViewModel(service: networkingService)
    }
}

// MARK: - Environment Keys

private struct DependencyContainerKey: EnvironmentKey {
    static let defaultValue = DependencyContainer.shared
}

extension EnvironmentValues {
    var dependencies: DependencyContainer {
        get { self[DependencyContainerKey.self] }
        set { self[DependencyContainerKey.self] = newValue }
    }
}

// MARK: - View Modifier for Dependencies

struct WithDependencies: ViewModifier {
    let dependencies: DependencyContainer
    
    func body(content: Content) -> some View {
        content
            .environment(\.dependencies, dependencies)
    }
}

extension View {
    func withDependencies(_ dependencies: DependencyContainer = .shared) -> some View {
        modifier(WithDependencies(dependencies: dependencies))
    }
}
