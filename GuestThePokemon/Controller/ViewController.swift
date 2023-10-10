//
//  ViewController.swift
//  GuestThePokemon
//
//  Created by Jose Daniel Corredor Zambrano on 9/10/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet var answerButtons: [UIButton]!
    
    lazy var pokemonListManager = PokemonListManager()
    lazy var pokemonManager = PokemonManager()
    
    var randomFourPokemons: [PokemonListModel] = []
    var correctAnswer: String = ""
    var correctImage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gives the power to "auto" invoke the func didUpdatePokemon, as soon as it recognizes a change
        pokemonListManager.delegate = self
        pokemonManager.delegate = self
        
        // Do any additional setup after loading the view.
        
        //Can set a shawod to the button, using the colors from each pokemon
        
        // Meanwhile set button properties
        pokemonListManager.fetchPokemonApi()
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        // With .title didnt work
//        print(sender.titleLabel?.text!)
    }
    
    func createButtons(){
        for button in answerButtons {
            button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
            button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            button.layer.shadowOpacity = 1.0
            button.layer.shadowRadius = 0
            button.layer.cornerRadius = 10.0
            button.layer.masksToBounds = true
        }
    }
}

// To avoid the saturation or the class ViewController with more extends, a "polite" way is the mentioned below
extension ViewController: PokemonListManagerDelegate {
    func didUpdatePokemons(pokemons: [PokemonListModel]) {
        randomFourPokemons = pokemons.choose(4)
//        print(randomFourPokemons)
        let index = Int.random(in: 0...3)
        let imageData = randomFourPokemons[index].pokemonURL
        correctAnswer = randomFourPokemons[index].name
        
        pokemonManager.fetchPokemon(url: imageData)
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}

extension ViewController: PokemonManagerDelegate {
    func didUpdatePokemon(pokemon: PokemonModel){
        print(pokemon)
    }
    
    func didFailWithErrorPokemon(error:Error) {
        print(error)
    }
}

// To avoid select an index  greater that the available
extension Collection where Indices.Iterator.Element == Index {
    // Subscript is used  to add the property to access by indices, like  with "[]"
    public subscript(safe index: Index) -> Iterator.Element?{
        return (startIndex <= index && index < endIndex) ? self[index] : nil
    }
}

extension Collection {
    func choose(_ n: Int) -> Array<Element> {
        Array(shuffled().prefix(n))
    }
}
