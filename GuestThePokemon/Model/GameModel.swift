//
//  GameModel.swift
//  GuestThePokemon
//
//  Created by Jose Daniel Corredor Zambrano on 10/10/23.
//

import Foundation


struct GamenModel {
    var score = 0
    
    //Check correct answer
    mutating func checkAnswer(_ userAnswer: String,_ correctAnswer: String) -> Bool{
        if userAnswer.lowercased() == correctAnswer.lowercased() {
            score += 1
            return true
        }
        return false
    }
    
    //Obtain Score
    func obtainScore() -> Int {
        return self.score
    }
    
    // Reset
    mutating func reset(score: Int) {
        // Using the reserved word "mutating" alow us to chance in some manner the struct value
        self.score = score
    }
}
