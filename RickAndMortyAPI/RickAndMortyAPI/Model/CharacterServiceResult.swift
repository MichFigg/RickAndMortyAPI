//
//  CharacterServiceResult.swift
//  RickAndMortyAPI
//
//  Created by Michał Figwer on 20/05/2024.
//

struct CharacterServiceResult: Codable {
    let results: [Character]
}

struct Character: Codable {
    let id: Int
    let name: String
}
