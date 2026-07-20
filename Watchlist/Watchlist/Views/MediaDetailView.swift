// MediaDetailView.swift
// Detailscherm voor een media-item.

import SwiftUI

struct MediaDetailView: View {
    @State var mediaItem: MediaItem
    @State private var isLoading = false
    @State private var showSaveAlert = false
    @State private var saveError: String?
    @State private var notes: String = ""
    @State private var isSaved = false
    
    @Environment(\dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Poster
                if let posterUrl = mediaItem.posterUrl, let url = URL(string: posterUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .clipped()
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                }
                
                // Titel en type
                VStack(alignment: .leading, spacing: 8) {
                    Text(mediaItem.title)
                        .font(.title)
                        .bold()
                    
                    HStack {
                        Text(mediaItem.mediaType.rawValue)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        if let year = mediaItem.year {
                            Text("• \(year)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Basisinfo
                HStack {
                    if let runtime = mediaItem.runtime, runtime > 0 {
                        HStack {
                            Image(systemName: "clock")
                            Text("\(runtime) min")
                        }
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    }
                    
                    if let voteAverage = mediaItem.voteAverage {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f/10", voteAverage))
                        }
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                // Continenten
                if !mediaItem.continents.isEmpty {
                    HStack(alignment: .top) {
                        Image(systemName: "globe")
                        VStack(alignment: .leading) {
                            ForEach(mediaItem.continents, id: \.self) { continent in
                                Text(continent)
                            }
                        }
                    }
                    .font(.subheadline)
                    .padding(.horizontal)
                }
                
                // Genres
                if let genres = mediaItem.genres, !genres.isEmpty {
                    HStack(alignment: .top) {
                        Image(systemName: "film")
                        VStack(alignment: .leading) {
                            ForEach(genres, id: \.id) { genre in
                                Text(genre.name)
                            }
                        }
                    }
                    .font(.subheadline)
                    .padding(.horizontal)
                }
                
                // Streaming platforms
                if !mediaItem.streamingPlatforms.isEmpty {
                    HStack(alignment: .top) {
                        Image(systemName: "tv")
                        VStack(alignment: .leading) {
                            ForEach(mediaItem.streamingPlatforms, id: \.self) { platform in
                                Text(platform)
                            }
                        }
                    }
                    .font(.subheadline)
                    .padding(.horizontal)
                }
                
                // Samenvatting
                if let overview = mediaItem.overview, !overview.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Samenvatting")
                            .font(.headline)
                        Text(overview)
                            .font(.body)
                    }
                    .padding(.horizontal)
                }
                
                // Notities
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notities")
                        .font(.headline)
                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .navigationTitle(mediaItem.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isSaved {
                    Button(action: {
                        updateMediaItem()
                    }) {
                        Image(systemName: "checkmark")
                    }
                } else {
                    Button(action: {
                        saveMediaItem()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .alert("Opgeslagen!", isPresented: $showSaveAlert) {
            Button("OK") {
                dismiss()
            }
        }
        .alert("Fout", isPresented: .constant(saveError != nil)) {
            Button("OK") {
                saveError = nil
            }
        } message: {
            Text(saveError ?? "")
        }
        .onAppear {
            loadDetails()
            checkIfSaved()
        }
    }
    
    // Laad details
    private func loadDetails() {
        isLoading = true
        TMDBService.shared.getMediaDetails(
            mediaId: mediaItem.id,
            mediaType: mediaItem.mediaType
        ) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let detailedItem):
                    mediaItem = detailedItem
                case .failure(let error):
                    print("Fout bij laden details: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Controleer of het item al is opgeslagen
    private func checkIfSaved() {
        isSaved = MediaStorage.shared.isMediaItemSaved(mediaItem.id)
        if isSaved, let savedItem = MediaStorage.shared.getMediaItem(withId: mediaItem.id) {
            notes = savedItem.notes ?? ""
        }
    }
    
    // Sla het item op
    private func saveMediaItem() {
        isLoading = true
        var itemToSave = mediaItem
        itemToSave.notes = notes.isEmpty ? nil : notes
        MediaStorage.shared.saveMediaItem(itemToSave)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isLoading = false
            isSaved = true
            showSaveAlert = true
        }
    }
    
    // Werk het item bij
    private func updateMediaItem() {
        isLoading = true
        var itemToSave = mediaItem
        itemToSave.notes = notes.isEmpty ? nil : notes
        MediaStorage.shared.saveMediaItem(itemToSave)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isLoading = false
            showSaveAlert = true
        }
    }
}

struct MediaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleItem = MediaItem(
            id: 1,
            title: "Inception",
            originalTitle: "Inception",
            overview: "A thief who steals corporate secrets through the use of dream-sharing technology.",
            posterPath: "/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg",
            backdropPath: nil,
            voteAverage: 8.8,
            voteCount: 22000,
            releaseDate: "2010-07-16",
            runtime: 148,
            genres: [Genre(id: 28, name: "Action"), Genre(id: 878, name: "Science Fiction")],
            productionCountries: [ProductionCountry(iso_3166_1: "US", name: "United States of America")],
            mediaType: .movie,
            watchStatus: .toWatch,
            streamingPlatforms: ["Netflix"],
            notes: nil
        )
        MediaDetailView(mediaItem: sampleItem)
    }
}
