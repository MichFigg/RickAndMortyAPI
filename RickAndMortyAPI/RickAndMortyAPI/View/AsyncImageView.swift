//
//  AsyncImageView.swift
//  RickAndMortyAPI
//
//  Created by Michał Figwer on 20/05/2024.
//

import SwiftUI

struct AsyncImageView: View {
    
    var image: String
    
    var body: some View {
        AsyncImage(url: URL(string: image),
                   content: { image in
            image.resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 100)
                .shadow(color: .gray, radius: 10, x: 4, y: 4)
        }
                   , placeholder: {
            ProgressView()
        }
        )
    }
}
