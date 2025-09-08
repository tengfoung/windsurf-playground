import SwiftUI

@main
struct BOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()
    private let dependencies = DependencyContainer.shared
    
    var body: some Scene {
        WindowGroup {
            if appState.showSplash {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                appState.showSplash = false
                            }
                        }
                    }
            } else {
                MainTabView()
                    .withDependencies(dependencies)
                    .environmentObject(appState)
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Any app-wide setup can go here
        return true
    }
}

class AppState: ObservableObject {
    @Published var showSplash = true
}
