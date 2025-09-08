import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "house.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.blue)
                Text("Home")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Welcome to BOS App")
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
