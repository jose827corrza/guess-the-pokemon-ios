//
//  PokemonManager.swift
//  GuestThePokemon
//
//  Created by Jose Daniel Corredor Zambrano on 10/10/23.
//

import Foundation

struct PokemonManager {
    let pokemonURL: String = "https://pokeapi.co/api/v2/pokemon?limit=5"
    
    func fetchPokemonApi(){
        performRequest(with: pokemonURL)
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
                    print(error!)
                }
                if let safeData = data {
                    if let pokemon = self.parseJSON(pokemonData: safeData){
                        print(pokemon)
                    }
                }
                
            }
            //4. Start the task
            task.resume()
        }
        
    }
    
    private func parseJSON(pokemonData: Data) -> [PokemonModel]? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(PokemonData.self, from: pokemonData)
            let pokemons = decodedData.results?.map{
                PokemonModel(name: $0.name ?? "", pokemonURL: $0.url ?? "")
            }
            return pokemons
        } catch {
            return nil
        }
    }
}
