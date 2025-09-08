import SwiftUI

struct InsightsHeaderView: View {
    @Binding var searchText: String
    @Binding var selectedCategory: String
    let categories = ["All", "Top Picks", "Curated", "Flagship", "Strategy", "Reports"]
    
    var body: some View {
        VStack(spacing: 16) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search insights...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Category ScrollView
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories, id: \.self) { category in
                        CategoryButton(
                            title: category,
                            isSelected: selectedCategory == category,
                            action: {
                                withAnimation {
                                    selectedCategory = category
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
}

private struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .blue : .primary)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.blue.opacity(0.1) : Color.clear)
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: isSelected ? 1 : 0.5)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Previews

struct InsightsHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InsightsHeaderView(
                searchText: .constant(""),
                selectedCategory: .constant("All")
            )
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Light Mode")
            
            InsightsHeaderView(
                searchText: .constant("Bitcoin"),
                selectedCategory: .constant("Top Picks")
            )
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Dark Mode")
        }
    }
}
