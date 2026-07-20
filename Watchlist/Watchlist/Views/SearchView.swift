// SearchView.swift
// Scherm voor het zoeken naar films, series en documentaires.

import SwiftUI

struct SearchView: View {
    @State private var searchQuery = ""
    @State private var searchResults: [MediaItem] = []
    @State private var isSearching = false
    @State private var selectedItem: MediaItem?
    @State private var showDetail = false
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // Zoekbalk
                SearchBar(text: $searchQuery, isSearching: $isSearching, onSearch: searchMedia)
                    .padding(.top, 8)
                
                if isLoading {
                    ProgressView()
                        .padding()
                } else if isSearching {
                    if searchResults.isEmpty {
                        VStack {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                                .padding()
                            Text("Geen resultaten gevonden")
                                .font(.title3)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        // Toon zoekresultaten
                        List(searchResults) { item in
                            MediaRow(mediaItem: item)
                                .onTapGesture {
                                    selectedItem = item
                                    showDetail = true
                                }
                        }
                        .listStyle(PlainListStyle())
                    }
                } else {
                    // Toon instructie
                    VStack {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Zoek een film, serie of documentaire")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Zoeken")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $selectedItem) { item in
                MediaDetailView(mediaItem: item)
            }
        }
    }
    
    // Zoek naar media
    private func searchMedia() {
        guard !searchQuery.isEmpty else {
            searchResults = []
            return
        }
        
        isLoading = true
        TMDBService.shared.searchMedia(query: searchQuery) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let items):
                    searchResults = items
                case .failure(let error):
                    print("Fout bij zoeken: \(error.localizedDescription)")
                    searchResults = []
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
