//
//  PokemonManager.swift
//  GuestThePokemon
//
//  Created by Jose Daniel Corredor Zambrano on 10/10/23.
//

import Foundation

// Way to pass the info from the manager to the controller
protocol PokemonListManagerDelegate {
    // Just stablishes what munt contains but DO NOT what it does
    
    func didUpdatePokemons(pokemons: [PokemonListModel])
        // It wil excecute when it updates our pokemon list
    
    func didFailWithError(error:Error)
}

struct PokemonListManager {
    let pokemonURL: String = "https://pokeapi.co/api/v2/pokemon?limit=150"
    
    var delegate: PokemonListManagerDelegate?
    
    
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
//                    print(error!)
                    self.delegate?.didFailWithError(error: error!)
                }
                if let safeData = data {
                    if let pokemons = self.parseJSON(pokemonData: safeData){
//                        print(pokemon)
                        self.delegate?.didUpdatePokemons(pokemons: pokemons)
                    }
                }
                
            }
            //4. Start the task
            task.resume()
        }
        
    }
    
    private func parseJSON(pokemonData: Data) -> [PokemonListModel]? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(PokemonListData.self, from: pokemonData)
            let pokemons = decodedData.results?.map{
                PokemonListModel(name: $0.name ?? "", pokemonURL: $0.url ?? "")
            }
            return pokemons
        } catch {
            return nil
        }
    }
}
