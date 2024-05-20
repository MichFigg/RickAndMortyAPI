//
//  CharacterViewModel.swift
//  RickAndMortyAPI
//
//  Created by Michał Figwer on 20/05/2024.
//

import SwiftUI

@MainActor
class CharacterViewModel: ObservableObject {
    
    enum State {
        case initialState
        case loading
        case successLoadingCharacters(data: [CurrentCharacterViewModel])
        case failed(error: Error)
    }
    
    @Published private(set) var state: State = .initialState
    @Published var hasError: Bool = false
    @Published var currentCharacters: [CurrentCharacterViewModel] = []
    @Published var rickAndMortyURL = "https://rickandmortyapi.com/api/character/?page=1&name="
    
    private let webService: WebService
    
    init(webService: WebService) {
        self.webService = webService
    }
    
    func getTotalNumberOfCharacters(currentCharacters: [CurrentCharacterViewModel]) -> Int {
        var count: Int = 1
        for currentCharacter in currentCharacters {
            count = currentCharacter.characterCount
        }
        return count
    }
    
    func getTotalNumberOfPages(currentCharacters: [CurrentCharacterViewModel]) -> Int {
        var count: Int = 1
        for currentCharacter in currentCharacters {
            count = currentCharacter.pageCount
        }
        return count
    }
    
    func populateCharacters(url: String) async {
        do {
            let currentCharacter = try await webService.fetchCharacters(url: url)
            if let character = currentCharacter {
                let currentCharacterViewModel = CurrentCharacterViewModel(id: UUID(), info: character.info, results: character.results) 
                self.currentCharacters.append(currentCharacterViewModel)
                
                self.state = .successLoadingCharacters(data: currentCharacters)
            }
        } catch {
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
    
    struct CurrentCharacterViewModel: Identifiable {
        
        var id = UUID()
        
        let info: Info
        let results: [Result]
        
        var pageCount: Int {
            info.pages
        }
        var characterCount: Int {
            info.count
        }
        var nextURL: String? {
            info.next
        }
        var previousURL: String? {
            info.prev
        }
    }
}
