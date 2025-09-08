import SwiftUI

// Replace deprecated statusBarFrame with windowScene.statusBarManager
var statusBarHeight: CGFloat {
    // Find the active window scene and read status bar height
    let scenes = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
    
    // Prefer the foregroundActive scene if available
    let activeScene = scenes.first(where: { $0.activationState == .foregroundActive }) ?? scenes.first
    
    let height = activeScene?.statusBarManager?.statusBarFrame.height ?? 0
    return height
}

@main
struct BOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()
    
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
