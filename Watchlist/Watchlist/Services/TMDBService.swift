// TMDBService.swift
// Service voor het ophalen van data van TMDB.

import Foundation

// Fouten voor netwerkoperaties
enum NetworkError: Error {
    case invalidUrl
    case noData
    case decodingError
    case noResults
    
    var localizedDescription: String {
        switch self {
        case .invalidUrl: return "Ongeldige URL"
        case .noData: return "Geen data ontvangen"
        case .decodingError: return "Fout bij decoderen van data"
        case .noResults: return "Geen resultaten gevonden"
        }
    }
}

// Service voor TMDB API-calls
class TMDBService {
    static let shared = TMDBService()
    
    private init() {}
    
    // Zoek naar media (films, series, documentaires)
    func searchMedia(query: String, completion: @escaping (Result<[MediaItem], Error>) -> Void) {
        // Controleer of de query leeg is
        guard !query.isEmpty else {
            completion(.failure(NetworkError.noResults))
            return
        }
        
        // Bouw de URL
        let urlString = "\(Config.tmdbBaseUrl)/search/multi?api_key=\(Config.tmdbApiKey)&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&include_adult=false&language=nl-NL"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }
        
        // Voer de request uit
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(TMDBSearchResponse.self, from: data)
                
                // Converteer zoekresultaten naar MediaItem
                let mediaItems = response.results.compactMap { result -> MediaItem? in
                    guard let mediaType = result.mediaType else { return nil }
                    
                    return MediaItem(
                        id: result.id,
                        title: result.title ?? result.name ?? "Onbekend",
                        originalTitle: result.original_title ?? result.original_name,
                        overview: result.overview,
                        posterPath: result.poster_path,
                        backdropPath: result.backdrop_path,
                        voteAverage: result.vote_average,
                        voteCount: result.vote_count,
                        releaseDate: result.release_date ?? result.first_air_date,
                        runtime: nil, // Wordt later opgevuld
                        genres: nil, // Wordt later opgevuld
                        productionCountries: nil, // Wordt later opgevuld
                        mediaType: mediaType,
                        watchStatus: .toWatch,
                        streamingPlatforms: [], // Wordt later opgevuld
                        notes: nil
                    )
                }
                
                completion(.success(mediaItems))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Haal details op voor een specifiek media-item
    func getMediaDetails(mediaId: Int, mediaType: MediaType, completion: @escaping (Result<MediaItem, Error>) -> Void) {
        let typeString = mediaType == .movie ? "movie" : "tv"
        let urlString = "\(Config.tmdbBaseUrl)/\(typeString)/\(mediaId)?api_key=\(Config.tmdbApiKey)&append_to_response=watch/providers&language=nl-NL"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                // Probeer eerst als film te decoderen
                if typeString == "movie" {
                    let movieResponse = try decoder.decode(TMDBMovieDetailResponse.self, from: data)
                    let mediaItem = self.createMediaItem(from: movieResponse, mediaType: mediaType)
                    completion(.success(mediaItem))
                }
                // Anders als serie
                else {
                    let tvResponse = try decoder.decode(TMDBTVDetailResponse.self, from: data)
                    let mediaItem = self.createMediaItem(from: tvResponse, mediaType: mediaType)
                    completion(.success(mediaItem))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Haal streaming platforms op voor een media-item
    func getStreamingPlatforms(mediaId: Int, mediaType: MediaType, completion: @escaping (Result<[String], Error>) -> Void) {
        let typeString = mediaType == .movie ? "movie" : "tv"
        let urlString = "\(Config.tmdbBaseUrl)/\(typeString)/\(mediaId)/watch/providers?api_key=\(Config.tmdbApiKey)&language=nl-NL"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(TMDBWatchProviders.self, from: data)
                
                // Haal Nederlandse streaming platforms op
                let nlProviders = response.results?.first { $0.iso_3166_1 == Config.countryCode }
                let platforms = nlProviders?.flatrate?.compactMap { $0.provider_name } ?? []
                
                completion(.success(platforms))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Maak een MediaItem van een TMDBMovieDetailResponse
    private func createMediaItem(from movie: TMDBMovieDetailResponse, mediaType: MediaType) -> MediaItem {
        let productionCountries = movie.production_countries?.map { country in
            ProductionCountry(iso_3166_1: country.iso_3166_1, name: country.name)
        }
        
        // Haal streaming platforms op
        let nlProviders = movie.watch_providers?.results?.first { $0.iso_3166_1 == Config.countryCode }
        let streamingPlatforms = nlProviders?.flatrate?.compactMap { $0.provider_name } ?? []
        
        return MediaItem(
            id: movie.id,
            title: movie.title ?? "Onbekend",
            originalTitle: movie.original_title,
            overview: movie.overview,
            posterPath: movie.poster_path,
            backdropPath: movie.backdrop_path,
            voteAverage: movie.vote_average,
            voteCount: movie.vote_count,
            releaseDate: movie.release_date,
            runtime: movie.runtime,
            genres: movie.genres,
            productionCountries: productionCountries,
            mediaType: mediaType,
            watchStatus: .toWatch,
            streamingPlatforms: streamingPlatforms,
            notes: nil
        )
    }
    
    // Maak een MediaItem van een TMDBTVDetailResponse
    private func createMediaItem(from tv: TMDBTVDetailResponse, mediaType: MediaType) -> MediaItem {
        let productionCountries = tv.production_countries?.map { country in
            ProductionCountry(iso_3166_1: country.iso_3166_1, name: country.name)
        }
        
        // Haal streaming platforms op
        let nlProviders = tv.watch_providers?.results?.first { $0.iso_3166_1 == Config.countryCode }
        let streamingPlatforms = nlProviders?.flatrate?.compactMap { $0.provider_name } ?? []
        
        // Gebruik de eerste episode runtime als de serie runtime
        let runtime = tv.episode_run_time?.first
        
        return MediaItem(
            id: tv.id,
            title: tv.name ?? "Onbekend",
            originalTitle: tv.original_name,
            overview: tv.overview,
            posterPath: tv.poster_path,
            backdropPath: tv.backdrop_path,
            voteAverage: tv.vote_average,
            voteCount: tv.vote_count,
            releaseDate: tv.first_air_date,
            runtime: runtime,
            genres: tv.genres,
            productionCountries: productionCountries,
            mediaType: mediaType,
            watchStatus: .toWatch,
            streamingPlatforms: streamingPlatforms,
            notes: nil
        )
    }
}
