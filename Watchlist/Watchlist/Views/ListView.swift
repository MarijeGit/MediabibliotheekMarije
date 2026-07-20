// ListView.swift
// Scherm met de opgeslagen media-items en filters.

import SwiftUI

struct ListView: View {
    @State private var mediaItems: [MediaItem] = []
    @State private var sortOption: SortOption = .title
    @State private var filterStatus: WatchStatus? = nil
    @State private var filterMediaType: MediaType? = nil
    @State private var filterContinent: String? = nil
    @State private var filterPlatform: String? = nil
    @State private var runtimeRange: ClosedRange<Int> = 0...300
    @State private var showExportMenu = false
    
    // Sorteeropties
    enum SortOption: String, CaseIterable {
        case title = "Titel"
        case runtime = "Duur"
        case releaseDate = "Release Datum"
        case voteAverage = "Beoordeling"
    }
    
    // Gefilterde items
    var filteredItems: [MediaItem] {
        var result = mediaItems
        
        // Filter op status
        if let status = filterStatus {
            result = result.filter { $0.watchStatus == status }
        }
        
        // Filter op media type
        if let type = filterMediaType {
            result = result.filter { $0.mediaType == type }
        }
        
        // Filter op continent
        if let continent = filterContinent {
            result = result.filter { item in
                item.continents.contains(continent)
            }
        }
        
        // Filter op platform
        if let platform = filterPlatform {
            result = result.filter { $0.streamingPlatforms.contains(platform) }
        }
        
        // Filter op duur
        result = result.filter { item in
            guard let runtime = item.runtime else { return false }
            return runtime >= runtimeRange.lowerBound && runtime <= runtimeRange.upperBound
        }
        
        // Sorteer
        switch sortOption {
        case .title:
            result.sort { $0.title < $1.title }
        case .runtime:
            result.sort { ($0.runtime ?? 0) < ($1.runtime ?? 0) }
        case .releaseDate:
            result.sort {
                let date1 = $0.releaseDate ?? "9999-01-01"
                let date2 = $1.releaseDate ?? "9999-01-01"
                return date1 < date2
            }
        case .voteAverage:
            result.sort { ($0.voteAverage ?? 0) > ($1.voteAverage ?? 0) }
        }
        
        return result
    }
    
    // Beschikbare continenten
    var availableContinents: [String] {
        let allContinents = mediaItems.flatMap { $0.continents }
        return Array(Set(allContinents)).sorted()
    }
    
    // Beschikbare platforms
    var availablePlatforms: [String] {
        let allPlatforms = mediaItems.flatMap { $0.streamingPlatforms }
        return Array(Set(allPlatforms)).sorted()
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        // Sorteeropties
                        Picker("Sorteer", selection: $sortOption) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                        .pickerStyle(.menu)
                        .buttonStyle(.bordered)
                        
                        // Status filter
                        Picker("Status", selection: $filterStatus) {
                            Text("Alle").tag(nil as WatchStatus?)
                            ForEach(WatchStatus.allCases, id: \.self) { status in
                                Text(status.rawValue).tag(status as WatchStatus?)
                            }
                        }
                        .pickerStyle(.menu)
                        .buttonStyle(.bordered)
                        
                        // Media type filter
                        Picker("Type", selection: $filterMediaType) {
                            Text("Alle").tag(nil as MediaType?)
                            ForEach(MediaType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type as MediaType?)
                            }
                        }
                        .pickerStyle(.menu)
                        .buttonStyle(.bordered)
                        
                        // Continent filter
                        if !availableContinents.isEmpty {
                            Picker("Continent", selection: $filterContinent) {
                                Text("Alle").tag(nil as String?)
                                ForEach(availableContinents, id: \.self) { continent in
                                    Text(continent).tag(continent as String?)
                                }
                            }
                            .pickerStyle(.menu)
                            .buttonStyle(.bordered)
                        }
                        
                        // Platform filter
                        if !availablePlatforms.isEmpty {
                            Picker("Platform", selection: $filterPlatform) {
                                Text("Alle").tag(nil as String?)
                                ForEach(availablePlatforms, id: \.self) { platform in
                                    Text(platform).tag(platform as String?)
                                }
                            }
                            .pickerStyle(.menu)
                            .buttonStyle(.bordered)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                
                // Duur filter (slider)
                VStack(alignment: .leading) {
                    Text("Duur: \(runtimeRange.lowerBound) - \(runtimeRange.upperBound) min")
                        .font(.caption)
                    RangeSlider(value: $runtimeRange, in: 0...300)
                        .frame(width: 200)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                // Tabel met resultaten
                if filteredItems.isEmpty {
                    VStack {
                        Image(systemName: "film")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Geen items gevonden")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        // Tabel headers
                        HStack {
                            Text("Titel")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Type")
                                .font(.headline)
                                .frame(width: 80)
                            Text("Duur")
                                .font(.headline)
                                .frame(width: 60)
                            Text("Status")
                                .font(.headline)
                                .frame(width: 100)
                            Text("Score")
                                .font(.headline)
                                .frame(width: 60)
                        }
                        .padding(.vertical, 8)
                        
                        // Tabel rows
                        ForEach(filteredItems) { item in
                            HStack(alignment: .top) {
                                // Titel + poster
                                HStack(spacing: 8) {
                                    if let posterUrl = item.posterUrl, let url = URL(string: posterUrl) {
                                        AsyncImage(url: url) { image in
                                            image.resizable()
                                        } placeholder: {
                                            Color.gray
                                        }
                                        .frame(width: 40, height: 60)
                                        .cornerRadius(4)
                                    } else {
                                        Rectangle()
                                            .fill(Color.gray)
                                            .frame(width: 40, height: 60)
                                            .cornerRadius(4)
                                    }
                                    Text(item.title)
                                        .font(.subheadline)
                                        .lineLimit(2)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                // Type
                                Text(item.mediaType.rawValue)
                                    .font(.caption)
                                    .frame(width: 80, alignment: .leading)
                                
                                // Duur
                                if let runtime = item.runtime, runtime > 0 {
                                    Text("\(runtime) min")
                                        .font(.caption)
                                        .frame(width: 60, alignment: .leading)
                                } else {
                                    Text("-")
                                        .font(.caption)
                                        .frame(width: 60, alignment: .leading)
                                }
                                
                                // Status
                                Picker("", selection: Binding(
                                    get: { item.watchStatus },
                                    set: { newStatus in
                                        if let index = mediaItems.firstIndex(where: { $0.id == item.id }) {
                                            mediaItems[index].watchStatus = newStatus
                                            MediaStorage.shared.saveMediaItem(mediaItems[index])
                                        }
                                    }
                                )) {
                                    ForEach(WatchStatus.allCases, id: \.self) { status in
                                        Text(status.rawValue).tag(status)
                                    }
                                }
                                .pickerStyle(.menu)
                                .frame(width: 100)
                                
                                // Score
                                if let voteAverage = item.voteAverage {
                                    Text(String(format: "%.1f", voteAverage))
                                        .font(.caption)
                                        .frame(width: 60, alignment: .leading)
                                } else {
                                    Text("-")
                                        .font(.caption)
                                        .frame(width: 60, alignment: .leading)
                                }
                            }
                            .padding(.vertical, 4)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    deleteItem(item)
                                } label: {
                                    Label("Verwijder", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Mijn Watchlist")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: exportToCSV) {
                            Label("Exporteer naar CSV", systemImage: "square.and.arrow.up")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
            .onAppear {
                loadMediaItems()
            }
        }
    }
    
    // Laad media-items
    private func loadMediaItems() {
        mediaItems = MediaStorage.shared.getAllMediaItems()
    }
    
    // Verwijder een item
    private func deleteItem(_ item: MediaItem) {
        MediaStorage.shared.deleteMediaItem(withId: item.id)
        mediaItems.removeAll { $0.id == item.id }
    }
    
    // Exporteer naar CSV
    private func exportToCSV() {
        var csvString = "Titel,Type,Duur (min),Status,Score,Jaar,Continent,Platforms,Notities\n"
        
        for item in filteredItems {
            let title = "\"\(item.title.replacingOccurrences(of: "\"", with: "\"\""))\""
            let type = item.mediaType.rawValue
            let runtime = item.runtime?.description ?? ""
            let status = item.watchStatus.rawValue
            let score = item.voteAverage?.description ?? ""
            let year = item.year ?? ""
            let continents = item.continents.joined(separator: ", ")
            let platforms = item.streamingPlatforms.joined(separator: ", ")
            let notes = "\"\((item.notes ?? "").replacingOccurrences(of: "\"", with: "\"\""))\""
            
            let row = [title, type, runtime, status, score, year, continents, platforms, notes].joined(separator: ",")
            csvString += row + "\n"
        }
        
        let fileName = "Watchlist_\(Date().formatted(date: .abbreviated, time: .omitted)).csv"
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        
        do {
            try csvString.write(to: path, atomically: true, encoding: .utf8)
            let activityViewController = UIActivityViewController(
                activityItems: [path],
                applicationActivities: nil
            )
            UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true)
        } catch {
            print("Fout bij exporteren: \(error.localizedDescription)")
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
