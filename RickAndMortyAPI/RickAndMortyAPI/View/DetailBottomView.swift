//
//  DetailBottomView.swift
//  RickAndMortyAPI
//
//  Created by Michał Figwer on 20/05/2024.
//

import SwiftUI


struct DetailBottomView: View {
    
    @StateObject var episodeVM = EpisodeViewModel(webService: WebService())
    
    var result: Result
    
    var body: some View {
        
        switch episodeVM.state {
        case .successLoadingEpisodes(let data):
            
            
            VStack (alignment: .leading, spacing: 8) {
                Text("Last known location:")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text(result.location.name)
                    .font(.headline)
                Text("First seen in:")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text(data[0].name)
                    .font(.headline)
                Divider()
                VStack {
                    Text("Appears in episodes:")
                        .font(.headline)
                    List {
                        ForEach(data) {
                            episode in
                            Text(episode.name)
                        }

                    }
                    .listStyle(.plain)
                }
                
            }
 
        default:
            Text("default")
                .alert("Error",
                       isPresented: $episodeVM.hasError,
                       presenting: episodeVM.state) { errorDetails in
                    Button("Retry") {
                        Task {
                            for episode in result.episode {
                                await episodeVM.populateEpisodes(url: episode)
                            }
                        }
                    }
                } message: { errorMessage in
                    if case let .failed(error) = errorMessage {
                        Text(" \(error.localizedDescription)")
                    }
                }
                .task {
                    await episodeVM.populateEpisodes(url: result.episode[0])
                    episodeVM.currentEpisodes.removeAll()
                }
        }
    }
}


struct DetailBottomView_Previews: PreviewProvider {
    static var previews: some View {
        DetailBottomView(result: Result(characterID: 94, name: "Diane Sanchez", status: .unknown, species: "Human", type: "", gender: .female, origin: Location(name: "Earth (Unknown dimension)", url: "https://rickandmortyapi.com/api/location/30"), location: Location(name: "Earth (Unknown dimension)", url: "https://rickandmortyapi.com/api/location/30"), image: "https://rickandmortyapi.com/api/character/avatar/94.jpeg", episode: ["https://rickandmortyapi.com/api/episode/22"], url: "https://rickandmortyapi.com/api/character/94", created: "2017-12-01T11:49:43.929Z"))
    }
}
