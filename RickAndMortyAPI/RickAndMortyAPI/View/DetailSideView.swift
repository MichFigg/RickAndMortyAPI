//
//  DetailSideView.swift
//  RickAndMortyAPI
//
//  Created by Michał Figwer on 20/05/2024.
//

import SwiftUI

struct DetailSideView: View {
   
        let result: Result
        
        var body: some View {
            
            VStack (alignment: .leading, spacing: 6) {
                HStack {
                    Text("Species: ")
                    Text(result.species + result.type)
                }
                        Text("Gender: \(result.gender.rawValue)")
                        Text("Status: \(result.status.rawValue)")
                        Text("ID: \(result.characterID)")
                    }
                    .foregroundColor(.secondary)
                    Spacer()
            }
}


