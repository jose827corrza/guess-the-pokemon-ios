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
    
    lazy var pokemonManager = PokemonManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Can set a shawod to the button, using the colors from each pokemon
        
        // Meanwhile set button properties
        pokemonManager.fetchPokemonApi()
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

