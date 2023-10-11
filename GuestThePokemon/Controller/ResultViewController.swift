//
//  ResultViewController.swift
//  GuestThePokemon
//
//  Created by Jose Daniel Corredor Zambrano on 10/10/23.
//

import UIKit
import Kingfisher

class ResultViewController: UIViewController {

    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    
    @IBOutlet weak var playAgainButton: UIButton!
    
    var pokemonName = ""
    var pokemonsImageUrl = ""
    var finalScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        labelScore.text = "Game over, your score was \(finalScore)"
        labelMessage.text = "No, its \(pokemonName.capitalized)"
        pokemonImage.kf.setImage(with: URL(string: pokemonsImageUrl))
    }

    @IBAction func playAgainButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
