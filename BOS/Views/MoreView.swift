import SwiftUI

struct MoreView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 50))
                    .foregroundColor(.gray)
                Text("More")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Additional options will appear here")
                    .foregroundColor(.secondary)
            }
            .navigationTitle("More")
        }
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}
