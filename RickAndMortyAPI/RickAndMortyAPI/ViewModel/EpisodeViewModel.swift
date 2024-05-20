//
//  EpisodeViewModel.swift
//  RickAndMortyAPI
//
//  Created by Michał Figwer on 20/05/2024.
//

import Foundation

@MainActor
class EpisodeViewModel: ObservableObject {
    
    enum State {
        case initialState
        case loading
        case successLoadingEpisodes(data: [CurrentEpisodeViewModel])
        case failed(error: Error)
    }
    
    @Published private(set) var state: State = .initialState
    @Published var hasError: Bool = false
    @Published var currentEpisodes: [CurrentEpisodeViewModel] = []
    
    private let webService: WebService
    
    init(webService: WebService) {
        self.webService = webService
    }
    
    func populateEpisodes(url: String) async {
        do {
            let currentEpisode = try await webService.fetchEpisodes(url: url)
            if let episode = currentEpisode {
                let currentEpisodeViewModel = CurrentEpisodeViewModel(name: episode.name)
                self.currentEpisodes.append(currentEpisodeViewModel)
                self.state = .successLoadingEpisodes(data: currentEpisodes)
            }
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
    struct CurrentEpisodeViewModel: Identifiable {
        
        let id = UUID()
        let name: String
        
    }
}
