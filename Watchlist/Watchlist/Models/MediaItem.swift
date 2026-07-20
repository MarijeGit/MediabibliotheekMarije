// MediaItem.swift
// Model voor films, series en documentaires.

import Foundation

// Type media: Film, Serie of Documentaire
enum MediaType: String, Codable, CaseIterable {
    case movie = "Film"
    case tv = "Serie"
    case documentary = "Documentaire"
}

// Status: To Watch, Watching, Watched
enum WatchStatus: String, Codable, CaseIterable {
    case toWatch = "Nog kijken"
    case watching = "Aan het kijken"
    case watched = "Bekeken"
}

// Model voor een media-item (film, serie, documentaire)
struct MediaItem: Identifiable, Codable {
    let id: Int // TMDB ID
    let title: String
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double?
    let voteCount: Int?
    let releaseDate: String? // YYYY-MM-DD
    let runtime: Int? // Minuten
    let genres: [Genre]?
    let productionCountries: [ProductionCountry]?
    let mediaType: MediaType
    var watchStatus: WatchStatus
    var streamingPlatforms: [String] // Bijv. ["Netflix", "Disney+"]
    var notes: String?
    
    // Bereken de poster-URL
    var posterUrl: String? {
        guard let path = posterPath else { return nil }
        return "\(Config.tmdbImageBaseUrl)\(path)"
    }
    
    // Bereken de backdrop-URL
    var backdropUrl: String? {
        guard let path = backdropPath else { return nil }
        return "\(Config.tmdbImageBaseUrl)\(path)"
    }
    
    // Haal het jaar uit de releaseDate
    var year: String? {
        guard let date = releaseDate else { return nil }
        return String(date.prefix(4))
    }
    
    // Haal de continenten op (gebaseerd op productielanden)
    var continents: [String] {
        guard let countries = productionCountries else { return [] }
        var continents: Set<String> = []
        
        for country in countries {
            let countryName = country.name.lowercased()
            
            // Europa
            if countryName.contains("netherlands") || 
               countryName.contains("belgium") || 
               countryName.contains("germany") || 
               countryName.contains("france") || 
               countryName.contains("united kingdom") || 
               countryName.contains("spain") || 
               countryName.contains("italy") || 
               countryName.contains("sweden") || 
               countryName.contains("norway") || 
               countryName.contains("denmark") || 
               countryName.contains("finland") || 
               countryName.contains("poland") {
                continents.insert("Europa")
            }
            // Noord-Amerika
            else if countryName.contains("united states") || 
                     countryName.contains("canada") || 
                     countryName.contains("mexico") {
                continents.insert("Noord-Amerika")
            }
            // Azië
            else if countryName.contains("china") || 
                     countryName.contains("japan") || 
                     countryName.contains("south korea") || 
                     countryName.contains("india") || 
                     countryName.contains("thailand") || 
                     countryName.contains("vietnam") {
                continents.insert("Azië")
            }
            // Zuid-Amerika
            else if countryName.contains("brazil") || 
                     countryName.contains("argentina") || 
                     countryName.contains("colombia") {
                continents.insert("Zuid-Amerika")
            }
            // Afrika
            else if countryName.contains("south africa") || 
                     countryName.contains("nigeria") || 
                     countryName.contains("egypt") {
                continents.insert("Afrika")
            }
            // Oceanië
            else if countryName.contains("australia") || 
                     countryName.contains("new zealand") {
                continents.insert("Oceanië")
            }
        }
        
        return Array(continents).sorted()
    }
}

// Genre-model
struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}

// Productieland-model
struct ProductionCountry: Codable {
    let iso_3166_1: String
    let name: String
}
