// MediaStorage.swift
// Service voor het opslaan en ophalen van media-items.

import Foundation

// Service voor lokale opslag van media-items
class MediaStorage {
    static let shared = MediaStorage()
    private let storageKey = "savedMediaItems"
    
    private init() {}
    
    // Sla een media-item op
    func saveMediaItem(_ item: MediaItem) {
        var items = getAllMediaItems()
        
        // Vervang bestaand item of voeg nieuw item toe
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        } else {
            items.append(item)
        }
        
        saveItems(items)
    }
    
    // Haal alle media-items op
    func getAllMediaItems() -> [MediaItem] {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let items = try? JSONDecoder().decode([MediaItem].self, from: data) {
            return items
        }
        return []
    }
    
    // Verwijder een media-item
    func deleteMediaItem(withId id: Int) {
        var items = getAllMediaItems()
        items.removeAll { $0.id == id }
        saveItems(items)
    }
    
    // Controleer of een item al is opgeslagen
    func isMediaItemSaved(_ id: Int) -> Bool {
        return getAllMediaItems().contains { $0.id == id }
    }
    
    // Haal een specifiek item op
    func getMediaItem(withId id: Int) -> MediaItem? {
        return getAllMediaItems().first { $0.id == id }
    }
    
    // Sla alle items op
    private func saveItems(_ items: [MediaItem]) {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}
