//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Game: Codable, Identifiable {
    let id: Int
    let team: String
    let opponent: String
    let isHomeGame: Bool
    let date: String
    let score: Score
}

struct Score: Codable {
    let opponent: Int
    let unc: Int
}

import SwiftUI

struct ContentView: View {
    @State private var games: [Game] = []
    
    var body: some View {
        NavigationView {
            List(games) { game in
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(game.team) vs. \(game.opponent)")
                            .font(.headline)
                        
                        Spacer()
                        
                        Text("\(game.score.unc) - \(game.score.opponent)")
                            .font(.headline)
                    }
                    
                    HStack {
                        Text(game.date)
                        
                        Spacer()
                        
                        Text(game.isHomeGame ? "Home" : "Away")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("UNC Basketball")
        }
        .task {
            await loadData()
        }
    }
    
    // Data Fetching from the vid
    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            // Decode from the vid
            let decodedGames = try JSONDecoder().decode([Game].self, from: data)
            games = decodedGames
        } catch {
            print("Failed to load data")
        }
    }
}

#Preview {
    ContentView()
}
