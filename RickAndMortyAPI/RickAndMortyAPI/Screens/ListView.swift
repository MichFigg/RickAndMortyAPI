//
//  ListView.swift
//  RickAndMortyAPI
//
//  Created by Michał Figwer on 20/05/2024.
//

import SwiftUI

struct ListView: View {
    
    @StateObject private var characterVM = CharacterViewModel(webService: WebService())
    
    @State var currentPage = 1
    @State var currentUrl = ""
    
    
    var body: some View {
        
        NavigationView {
            switch characterVM.state {
            case .successLoadingCharacters(let data):
                VStack {
                    
                    List {
                        
                        ForEach(data) {
                            arrayOfResult in
                            ForEach(arrayOfResult.results) {
                                result in
                                
                                VStack {
                                    NavigationLink(destination: DetailView(result: result)) {
                                        RowView(result: result)
                                            .task {
                                                
                                                if result == arrayOfResult.results.last && (arrayOfResult.nextURL  != nil) && (arrayOfResult.nextURL != currentUrl)
                                                {
                                                    
                                                    await characterVM.populateCharacters(url: arrayOfResult.nextURL!)
                                                    self.currentUrl = arrayOfResult.nextURL!
                                                    
                                                    self.currentPage += 1
                                                }
                                            }
                                            
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbar {
                                    ToolbarItem(placement: .principal) {
                                        ZStack {
                                            Color.yellow
                                                .edgesIgnoringSafeArea(.top)
                                            HStack {
                                                Spacer()
                                                Text("Rick and Morty API")
                                                    .font(.headline)
                                                    .foregroundColor(.black)
                                                Spacer()
                                            }
                                        }
                                        .frame(height: 44)
                                    }
                                }
            case .loading:
                ProgressView()
                
            default:
                Text("Loading")
                
            }
        }
        
        .refreshable {
            currentPage = 1
            characterVM.currentCharacters.removeAll()
            await
            characterVM.populateCharacters(url: characterVM.rickAndMortyURL)
        }
        
        .alert("Error",
               isPresented: $characterVM.hasError,
               presenting: characterVM.state) { errorDetails in
            Button("Retry") {
                Task {
                    await characterVM.populateCharacters(url: currentUrl)
                }
            }
        } message: { errorMessage in
            if case let .failed(error) = errorMessage {
                Text(" \(error.localizedDescription)")
            }
        }
        
        .task {

            currentPage = 1
            await
            characterVM.populateCharacters(url: characterVM.rickAndMortyURL)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .preferredColorScheme(.light)
    }
}
