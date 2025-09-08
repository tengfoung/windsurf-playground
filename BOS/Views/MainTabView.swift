import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 3 // Default to Insights tab (0-based index)
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            WatchlistsView()
                .tabItem {
                    Label("Watchlists", systemImage: "star")
                }
                .tag(1)
            
            TradeView()
                .tabItem {
                    Label("Trade", systemImage: "arrow.left.arrow.right")
                }
                .tag(2)
            
            InsightsView()
                .tabItem {
                    Label("Insights", systemImage: "lightbulb")
                }
                .tag(3)
            
            MoreView()
                .tabItem {
                    Label("More", systemImage: "ellipsis")
                }
                .tag(4)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
