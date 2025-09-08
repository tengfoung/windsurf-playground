import SwiftUI

struct ArticleCard: View {
    let article: Article
    let isCompact: Bool
    var onShare: (() -> Void)? = nil
    
    @State private var isShowingShareSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Image with play button if video is available
            ZStack(alignment: .center) {
                // Image or placeholder
                if let imageUrl = article.imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()                 // fill horizontally, preserve intrinsic ratio
                                .frame(maxWidth: .infinity)     // take available width
                                .clipped()                      // crop overflow vertically
                        case .failure, .empty:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.gray)
                                .background(Color.gray.opacity(0.3))
                                .clipped()
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Color.gray.opacity(0.3)
                        .frame(maxWidth: .infinity)
                        .clipped()
                }
                
                // Play button for videos
                if article.hasVideo {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                }
            }
            .frame(maxWidth: .infinity)
            .cornerRadius(8)
            .clipped()
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                // Title and hook
                Text(article.title)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                Text(article.hook)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                if !isCompact {
                    Text(article.description ?? "")
                        .font(.body)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                }
                
                // Date and tags
                HStack {
                    if let date = DateFormatter.yyyyMMdd.date(from: article.date) {
                        Text(DateFormatter.MMMdyyyy.string(from: date))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if let indicators = article.indicators {
                        HStack(spacing: 8) {
                            if indicators.onHoldings {
                                IndicatorView(type: .onHoldings)
                            }
                            if indicators.onWatchlist {
                                IndicatorView(type: .onWatchlist)
                            }
                            if indicators.onSubscription {
                                IndicatorView(type: .subscribed)
                            }
                        }
                    }
                }
                
                // Tags
                if !article.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(article.tags.prefix(3)) { tag in
                                TagView(tag: tag)
                            }
                        }
                    }
                }
            }
            
            // Actions
            HStack {
                Button(action: {
                    isShowingShareSheet = true
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share")
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
                .buttonStyle(BorderlessButtonStyle())
                .sheet(isPresented: $isShowingShareSheet) {
                    if let url = URL(string: "https://example.com/article/\(article.id)") {
                        ShareSheet(activityItems: [url])
                    }
                }
                
                Spacer()
                
                if isCompact {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        //.shadow(radius: isCompact ? 2 : 4, x: 0, y: isCompact ? 1 : 2)
    }
}

// MARK: - Subviews

private struct TagView: View {
    let tag: Tag
    
    var body: some View {
        Text(tag.name)
            .font(.caption2)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.blue.opacity(0.1))
            .foregroundColor(.blue)
            .cornerRadius(4)
    }
}

private struct IndicatorView: View {
    enum IndicatorType {
        case onHoldings
        case onWatchlist
        case subscribed
        
        var icon: String {
            switch self {
            case .onHoldings: return "checkmark.circle.fill"
            case .onWatchlist: return "bookmark.fill"
            case .subscribed: return "star.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .onHoldings: return .green
            case .onWatchlist: return .orange
            case .subscribed: return .yellow
            }
        }
    }
    
    let type: IndicatorType
    
    var body: some View {
        Image(systemName: type.icon)
            .foregroundColor(type.color)
            .imageScale(.small)
    }
}

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Date Formatter Extension

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let MMMdyyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()
}

// MARK: - Previews

struct ArticleCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ArticleCard(article: .mock, isCompact: false)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Expanded")
            
            ArticleCard(article: .mockWithVideo, isCompact: true)
                .previewLayout(.sizeThatFits)
                .frame(width: 300)
                .padding()
                .previewDisplayName("Compact with Video")
        }
    }
}
