// TMDBModels.swift
// Modellen voor TMDB API-responses.

import Foundation

// Zoekresultaat van TMDB
struct TMDBSearchResponse: Codable {
    let results: [TMDBSearchResult]
    let total_pages: Int
    let total_results: Int
    let page: Int
}

// Individueel zoekresultaat
struct TMDBSearchResult: Codable {
    let id: Int
    let media_type: String?
    let title: String?
    let name: String?
    let original_title: String?
    let original_name: String?
    let overview: String?
    let poster_path: String?
    let backdrop_path: String?
    let vote_average: Double?
    let vote_count: Int?
    let release_date: String?
    let first_air_date: String?
    let adult: Bool?
    
    // Bereken het media-type (film, serie, etc.)
    var mediaType: MediaType? {
        guard let type = media_type else { return nil }
        switch type {
        case "movie": return .movie
        case "tv": return .tv
        default: return .documentary
        }
    }
}

// Detailresponse voor een film
struct TMDBMovieDetailResponse: Codable {
    let id: Int
    let title: String?
    let original_title: String?
    let overview: String?
    let poster_path: String?
    let backdrop_path: String?
    let vote_average: Double?
    let vote_count: Int?
    let release_date: String?
    let runtime: Int?
    let genres: [Genre]?
    let production_countries: [TMDBProductionCountry]?
    let watch_providers: TMDBWatchProviders?
}

// Detailresponse voor een serie
struct TMDBTVDetailResponse: Codable {
    let id: Int
    let name: String?
    let original_name: String?
    let overview: String?
    let poster_path: String?
    let backdrop_path: String?
    let vote_average: Double?
    let vote_count: Int?
    let first_air_date: String?
    let episode_run_time: [Int]?
    let genres: [Genre]?
    let production_countries: [TMDBProductionCountry]?
    let watch_providers: TMDBWatchProviders?
}

// Productieland (van TMDB)
struct TMDBProductionCountry: Codable {
    let iso_3166_1: String
    let name: String
}

// Watch Providers (streaming platforms)
struct TMDBWatchProviders: Codable {
    let results: [TMDBProviderResult]?
}

struct TMDBProviderResult: Codable {
    let iso_3166_1: String
    let flatrate: [TMDBProvider]?
    let free: [TMDBProvider]?
    let ads: [TMDBProvider]?
}

struct TMDBProvider: Codable {
    let provider_name: String
    let logo_path: String?
    let provider_id: Int
    let priority: Int
}
