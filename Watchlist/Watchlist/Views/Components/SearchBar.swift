// SearchBar.swift
// Zoekbalk-component voor SwiftUI.

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @Binding var isSearching: Bool
    var onSearch: () -> Void
    
    var body: some View {
        HStack {
            TextField("Zoek een film, serie of documentaire...", text: $text)
                .padding(8)
                .padding(.horizontal, 24)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if !text.isEmpty {
                            Button(action: {
                                text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .onChange(of: text) { _ in
                    isSearching = !text.isEmpty
                    onSearch()
                }
        }
        .padding(.horizontal)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        @State var text = ""
        @State var isSearching = false
        SearchBar(text: $text, isSearching: $isSearching, onSearch: {})
    }
}
