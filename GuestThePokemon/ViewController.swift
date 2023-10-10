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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Can set a shawod to the button, using the colors from each pokemon
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
    }
    
}

