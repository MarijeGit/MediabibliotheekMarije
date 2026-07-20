// Config.swift
// Bevat API-sleutels en basis-URLs voor de app.

struct Config {
    // 🔑 Vervang dit door je eigen TMDB API-sleutel!
    // Haal een sleutel op via: https://www.themoviedb.org/settings/api
    static let tmdbApiKey = "JOUW_TMDB_API_SLEUTEL_HIER"
    
    // Basis-URLs voor TMDB
    static let tmdbBaseUrl = "https://api.themoviedb.org/3"
    static let tmdbImageBaseUrl = "https://image.tmdb.org/t/p/w500"
    
    // Landcode voor Nederland (voor streaming platforms)
    static let countryCode = "NL"
}
