//
//  WebService.swift
//  RickAndMortyAPI
//
//  Created by Michał Figwer on 20/05/2024.
//

import SwiftUI

struct WebService: Decodable {
    
    enum WebServiceError: Error {
        case genericFailure
        case failedToDecodeData
        case invalidStatusCode
    }
    
    func fetchCharacters(url: String) async throws -> APIResponse? {

 
        let (data, response) = try await URLSession.shared.data(from: URL(string: url)!)
        
        guard let networkRequestResponse = response as? HTTPURLResponse,
              networkRequestResponse.statusCode == 200 else {
                  throw WebServiceError.invalidStatusCode
              }
        
             let decodedData = try JSONDecoder().decode(APIResponse.self, from: data)
        return (decodedData.self)
    }
    
    func fetchEpisodes(url: String) async throws -> Episode? {
 
        let (data, response) = try await URLSession.shared.data(from: URL(string: url)!)
        
        guard let networkRequestResponse = response as? HTTPURLResponse,
              networkRequestResponse.statusCode == 200 else {
                  throw WebServiceError.invalidStatusCode
              }
        
        let decodedData = try JSONDecoder().decode(Episode.self, from: data)
        return (decodedData.self)
    }
}
