import SwiftUI

struct WatchlistsView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "star.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.yellow)
                Text("Watchlists")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Your watchlists will appear here")
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Watchlists")
        }
    }
}

struct WatchlistsView_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistsView()
    }
}
