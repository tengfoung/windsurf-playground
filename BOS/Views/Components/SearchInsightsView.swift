import SwiftUI

struct SearchInsightsView: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    let onSearch: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Search insights, reports, and more", text: $searchText, onCommit: onSearch)
                        .textFieldStyle(PlainTextFieldStyle())
                        .disableAutocorrection(true)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                if isSearching {
                    Button("Cancel") {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        searchText = ""
                    }
                    .foregroundColor(.blue)
                    .transition(.move(edge: .trailing))
                }
            }
            .padding()
            .animation(.easeInOut, value: isSearching)
        }
        .background(Color(.systemBackground))
    }
}

// MARK: - Previews

struct SearchInsightsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchInsightsView(
                searchText: .constant(""),
                isSearching: .constant(false),
                onSearch: {}
            )
            .previewDisplayName("Default")
            
            SearchInsightsView(
                searchText: .constant("Apple"),
                isSearching: .constant(true),
                onSearch: {}
            )
            .previewDisplayName("With Text")
        }
        .previewLayout(.sizeThatFits)
    }
}
