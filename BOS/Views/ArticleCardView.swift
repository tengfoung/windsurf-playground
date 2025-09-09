import SwiftUI

struct ArticleCardView: View {
    let article: Article
    var showIndicators: Bool = true
    var showTags: Bool = true
    var imageHeight: CGFloat = 180
    var showDescription: Bool = true
    var maxLines: Int = 3
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Image with optional video overlay
            ZStack(alignment: .topTrailing) {
                // Image
                AsyncImage(url: URL(string: article.imageUrl ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: imageHeight)
                            .clipped()
                            .cornerRadius(8)
                    case .failure(_):
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: imageHeight)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    case .empty:
                        ProgressView()
                            .frame(height: imageHeight)
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                // Video indicator
                if article.hasVideo == true {
                    Image(systemName: "play.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                        .padding(8)
                }
            }
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                // Category/Company if available
                if let category = article.category ?? article.company {
                    Text(category.uppercased())
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .lineLimit(1)
                }
                
                // Title
                Text(article.title)
                    .font(.headline)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Hook
                if !article.hook.isEmpty {
                    Text(article.hook)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                // Description (if shown)
                if showDescription && !article.description.isEmpty {
                    Text(article.description)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineLimit(maxLines)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                // Tags
                if showTags && !article.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(article.tags.prefix(3), id: \.self) { tag in
                                Text(tag)
                                    .font(.caption2)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(4)
                            }
                        }
                    }
                }
                
                // Footer
                HStack {
                    // Date
                    Text(article.formattedDate)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    // Indicators
                    if showIndicators, let indicators = article.indicators {
                        HStack(spacing: 8) {
                            if indicators.onHoldings {
                                Image(systemName: "briefcase")
                                    .foregroundColor(.green)
                                    .font(.caption)
                            }
                            if indicators.onSubscription {
                                Image(systemName: "star")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                            }
                            if indicators.onWatchlist {
                                Image(systemName: "bookmark")
                                    .foregroundColor(.blue)
                                    .font(.caption)
                            }
                        }
                    }
                    
                    // Share button
                    Button(action: {
                        // Share action
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.blue)
                            .font(.caption)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
    }
}

// MARK: - Preview
struct ArticleCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ArticleCardView(article: Article.sampleTopPicks[2])
                .previewLayout(.sizeThatFits)
                .padding()
            
            ArticleCardView(
                article: Article.sampleCuratedList[0],
                showIndicators: true,
                showTags: true,
                imageHeight: 150,
                showDescription: true,
                maxLines: 2
            )
            .previewLayout(.sizeThatFits)
            .padding()
            .preferredColorScheme(.dark)
        }
    }
}
