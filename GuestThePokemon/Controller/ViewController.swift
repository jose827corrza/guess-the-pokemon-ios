//
//  ViewController.swift
//  GuestThePokemon
//
//  Created by Jose Daniel Corredor Zambrano on 9/10/23.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet var answerButtons: [UIButton]!
    
    lazy var pokemonListManager = PokemonListManager()
    lazy var pokemonManager = PokemonManager()
    lazy var game = GamenModel()
    
    var randomFourPokemons: [PokemonListModel] = [] {
        didSet {
            // As soon as this receives info, this code runs
            setButtonsTitle()
        }
    }
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
        createButtons()
        pokemonListManager.fetchPokemonApi()
        labelMessage.text = ""
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        // With .title didnt work
        let userAnswer = sender.titleLabel?.text!
        if game.checkAnswer(userAnswer!, correctAnswer){
            labelMessage.text = "Yes, it's \(correctAnswer.capitalized)"
            labelScore.text = "Score: \(game.score)"
            
            sender.layer.borderColor = UIColor.systemGreen.cgColor
            sender.layer.borderWidth = 2
            
            let url = URL(string: correctImage)
            pokemonImage.kf.setImage(with: url)
            
            Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false){time in
                self.pokemonListManager.fetchPokemonApi()
                self.labelMessage.text = ""
                sender.layer.borderWidth = 0
            }
            
        }else{
            self.performSegue(withIdentifier: "goToResults", sender: self)
//            labelMessage.text = "NOOO, it's \(correctAnswer.capitalized)"
//            sender.layer.borderColor = UIColor.systemRed.cgColor
//            sender.layer.borderWidth = 2
//            let url = URL(string: correctImage)
//            pokemonImage.kf.setImage(with: url)
//
//            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false){time in
//                self.pokemonListManager.fetchPokemonApi()
//                self.resetGame()
//                sender.layer.borderWidth = 0
//            }
        }
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
    
    func resetGame() {
        self.pokemonListManager.fetchPokemonApi()
        self.labelScore.text = "Score: \(game.score)"
        self.labelMessage.text = ""
        game.reset(score: 0)
    }
    
    func setButtonsTitle() {
        for (index, button) in answerButtons.enumerated() {
            // Because we are using protocols and delegates, is a MUST to use Dispatch
            // This will allow us to work async, because we are using calls from a remote API
            // also is important to keep in mind, that this info must be send to the main thread
            DispatchQueue.main.async { [self] in // To avoid type self in every prop
                button.setTitle(randomFourPokemons[safe: index]?.name.capitalized, for: .normal)
            }
        }
    }
    
    // To move between views
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResults" {
            let destination = segue.destination as! ResultViewController
            destination.pokemonName = correctAnswer
            destination.pokemonsImageUrl = correctImage
            destination.finalScore = game.score
            resetGame()
        }
    }
}

// To avoid the saturation or the class ViewController with more extends, a "polite" way is the mentioned below
extension ViewController: PokemonListManagerDelegate {
    func didUpdatePokemons(pokemons: [PokemonListModel]) {
        let index = Int.random(in: 0...3)
        randomFourPokemons = pokemons.choose(4)
        let imageData = randomFourPokemons[index].pokemonURL
        pokemonManager.fetchPokemon(url: imageData)
        
        correctAnswer = randomFourPokemons[index].name
        print(correctAnswer)
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}

extension ViewController: PokemonManagerDelegate {
    func didUpdatePokemon(pokemon: PokemonModel){
//        print(pokemon)
        correctImage = pokemon.imageUrl
        
        DispatchQueue.main.async { [self] in
            let url = URL(string: pokemon.imageUrl)
            let effect = ColorControlsProcessor(brightness: -1, contrast: 1, saturation: 1, inputEV: 0)
            pokemonImage.kf.setImage(
                with: url,
                options: [
                    .processor(effect)
                ]
            )
        }
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
