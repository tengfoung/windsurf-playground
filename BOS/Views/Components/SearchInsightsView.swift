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
                        .foregroundColor(.white)
                    
                    TextField("Search insights, reports, and more", text: $searchText, onCommit: onSearch)
                        .textFieldStyle(PlainTextFieldStyle())
                        .disableAutocorrection(true)
                        .foregroundColor(.white)
                        .accentColor(.white)
                        .placeholder(when: searchText.isEmpty) {
                            Text("Search insights, reports, and more")
                                .foregroundColor(.white.opacity(0.8))
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(12)
                .background(Color.white.opacity(0.2))
                .cornerRadius(12)
                
                if isSearching {
                    Button("Cancel") {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        searchText = ""
                    }
                    .foregroundColor(.white)
                    .transition(.move(edge: .trailing))
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 8)
            .animation(.easeInOut, value: isSearching)
        }
        .background(Color.clear)
    }
}

// MARK: - View Extension for Placeholder

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
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
