//
//  ImageManager.swift
//  GuestThePokemon
//
//  Created by Jose Daniel Corredor Zambrano on 10/10/23.
//

import Foundation


protocol PokemonManagerDelegate {
    // Just stablishes what munt contains but DO NOT what it does
    
    func didUpdatePokemon(pokemon: PokemonModel)
        // It wil excecute when it updates our pokemon list
    
    func didFailWithErrorPokemon(error:Error)
}

struct PokemonManager {
    
    var delegate: PokemonManagerDelegate?
    
    func fetchPokemon(url: String) {
        performRequest(with: url)
    }
    
    private func performRequest(with urlString: String){
        // Steps to consume an API from the App
        //1. Create/Get URL
        if let url = URL(string: urlString){
            //2. Create the URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url){data, response, error in
                if error != nil{
//                    print(error!)
                    self.delegate?.didFailWithErrorPokemon(error: error!)
                }
                if let safeData = data {
                    if let pokemon = self.parseJSON(pokemonData: safeData){
//                        print(pokemon)
                        self.delegate?.didUpdatePokemon(pokemon: pokemon)
                    }
                }
                
            }
            //4. Start the task
            task.resume()
        }
        
    }
    
    private func parseJSON(pokemonData: Data) -> PokemonModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(PokemonData.self, from: pokemonData)
            let image = decodedData.sprites?.other?.officialArtwork?.frontDefault ?? ""
            return PokemonModel(imageUrl: image)

        } catch {
            return nil
        }
    }
}
