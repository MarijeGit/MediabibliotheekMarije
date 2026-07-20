// ContentView.swift
// Hoofdscherm met tabs voor Zoeken en Mijn Lijst.

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SearchView()
                .tabItem {
                    Label("Zoeken", systemImage: "magnifyingglass")
                }
            
            ListView()
                .tabItem {
                    Label("Mijn Lijst", systemImage: "list.bullet")
                }
        }
        .accentColor(.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
