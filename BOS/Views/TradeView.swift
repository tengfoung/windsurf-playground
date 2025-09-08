import SwiftUI

struct TradeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 50))
                    .foregroundColor(.green)
                Text("Trade")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Trading functionality will be available here")
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Trade")
        }
    }
}

struct TradeView_Previews: PreviewProvider {
    static var previews: some View {
        TradeView()
    }
}
