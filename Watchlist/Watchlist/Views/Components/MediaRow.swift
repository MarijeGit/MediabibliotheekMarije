// MediaRow.swift
// Rij voor media-items in de zoekresultaten.

import SwiftUI

struct MediaRow: View {
    let mediaItem: MediaItem
    
    var body: some View {
        HStack(spacing: 12) {
            // Poster
            if let posterUrl = mediaItem.posterUrl, let url = URL(string: posterUrl) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 50, height: 75)
                .cornerRadius(4)
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 50, height: 75)
                    .cornerRadius(4)
            }
            
            // Titel en info
            VStack(alignment: .leading, spacing: 4) {
                Text(mediaItem.title)
                    .font(.headline)
                    .lineLimit(2)
                
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
                
                if let voteAverage = mediaItem.voteAverage {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", voteAverage))
                            .font(.caption)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct MediaRow_Previews: PreviewProvider {
    static var previews: some View {
        let sampleItem = MediaItem(
            id: 1,
            title: "Inception",
            originalTitle: "Inception",
            overview: "A thief who steals corporate secrets...",
            posterPath: "/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg",
            backdropPath: nil,
            voteAverage: 8.8,
            voteCount: 22000,
            releaseDate: "2010-07-16",
            runtime: 148,
            genres: nil,
            productionCountries: nil,
            mediaType: .movie,
            watchStatus: .toWatch,
            streamingPlatforms: [],
            notes: nil
        )
        MediaRow(mediaItem: sampleItem)
    }
}
