//
//  PokemonData.swift
//  GuestThePokemon
//
//  Created by Jose Daniel Corredor Zambrano on 10/10/23.
//

import Foundation

struct PokemonListData: Codable {
    // Are not required
//    let count: Int
//    let next: Int
    let results: [Result]?
}

struct Result: Codable {
    let name: String?
    let url: String?
}
