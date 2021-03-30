//
//  BatllefieldViewController.swift
//  Transformers
//
//  Created by Alek Spitzer on 3/27/21.
//

import UIKit

class BattlefieldViewController: UIViewController, Storyboardable {

    // MARK: - Storyboardable
    static var storyboardName: String {
        return "BattlefieldViewController"
    }
    
    @IBOutlet weak var resultsTextView: UITextView!
    
    var transformers = [Transformer]()
    var eliminatedTransformers = [Transformer]()
    var winnerTransformers = [Transformer]()
    
    var sortedAutobots = [Transformer]()
    var sortedDecepticons = [Transformer]()
    
    var eliminatedAutobots = [Transformer]()
    var eliminatedDecepticons = [Transformer]()
    
    var battleCount: Int = 0
    
    let optimusPrime = "Optimus Prime"
    let predaking = "Predaking"
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startBattle() {
        clearCollections()
        
        let autobots = transformers.filter { (transformer) -> Bool in
            transformer.team.contains("A")
        }
        
        let decepticons = transformers.filter { (transformer) -> Bool in
            transformer.team.contains("D")
        }
        
        sortedAutobots = autobots.sorted {
            $0.rank < $1.rank
        }
        
        sortedDecepticons = decepticons.sorted {
            $0.rank < $1.rank
        }
        
        
        battleCount = calculateBattleCount(autobots, decepticons)
        
        for i in 0..<battleCount {
            let autobot = sortedAutobots[i]
            let decepticon = sortedDecepticons[i]

            // Any Transformer named Optimus Prime or Predaking wins his fight automatically regardless of any other criteria
            // In the event either of the above face each other (or a duplicate of each other), the game immediately ends with all competitors destroyed
            if autobot.name == optimusPrime && decepticon.name == optimusPrime || autobot.name == predaking && decepticon.name == predaking {
                gameOver()
                return
            }
            
            if (autobot.name == predaking && decepticon.name == optimusPrime) || (decepticon.name == predaking && autobot.name == optimusPrime) {
                gameOver()
                return
            }
            
            if autobot.name == optimusPrime || autobot.name == predaking {
                eliminatedTransformers.append(decepticon)
                winnerTransformers.append(autobot)
                continue
            }
            
            if decepticon.name == optimusPrime || decepticon.name == predaking {
                eliminatedTransformers.append(autobot)
                winnerTransformers.append(decepticon)
                continue
            }

            // If any fighter is down 4 or more points of courage and 3 or more points of strength
            // compared to their opponent, the opponent automatically wins the face-off regardless of
            // overall rating (opponent has ran away)
            if autobot.courage <= 4 && decepticon.strength - autobot.strength >= 3 {
                // Autobot ran away ...
                eliminatedTransformers.append(autobot)
                winnerTransformers.append(decepticon)
                continue
            }
            
            if decepticon.courage <= 4 && autobot.strength - decepticon.strength >= 3 {
                // Decepticon ran away ...
                eliminatedTransformers.append(decepticon)
                winnerTransformers.append(autobot)
                continue
            }
            
            // Otherwise, if one of the fighters is 3 or more points of skill above their opponent, they
            // win the fight regardless of overall rating
            if decepticon.skill - autobot.skill >= 3 {
                eliminatedTransformers.append(autobot)
                winnerTransformers.append(decepticon)
                continue
            }
            
            if autobot.skill - decepticon.skill >= 3 {
                eliminatedTransformers.append(decepticon)
                winnerTransformers.append(autobot)
                continue
            }

            // The winner is the Transformer with the highest overall rating
            if overallRating(transformer: autobot) > overallRating(transformer: decepticon) {
                eliminatedTransformers.append(decepticon)
                winnerTransformers.append(autobot)
                continue
            }
            
            if overallRating(transformer: decepticon) > overallRating(transformer: autobot) {
                eliminatedTransformers.append(autobot)
                winnerTransformers.append(decepticon)
                continue
            }
                    
            // In the event of a tie, both Transformers are considered destroyed
            if overallRating(transformer: autobot) == overallRating(transformer: decepticon) {
                eliminatedTransformers.append(autobot)
                eliminatedTransformers.append(decepticon)
                continue
            }
        }
        
        finishBattle()
    }
    
    private func clearCollections() {
        eliminatedTransformers.removeAll()
        winnerTransformers.removeAll()
        sortedAutobots.removeAll()
        sortedDecepticons.removeAll()
        eliminatedAutobots.removeAll()
        eliminatedDecepticons.removeAll()
    }
    
    private func gameOver() {
        resultsTextView.text = "GAME OVER ... All competitors were destroyed!"
    }
    
    private func finishBattle() {
        var text = "\(battleCount) Battle(s)\n\n"
        text = text + "\(winningTeamString())\n\n"
        text = text + "\(survivorsString())"
        
        
        resultsTextView.text = text
    }
    
    private func winningTeamString() -> String {
        eliminatedAutobots = eliminatedTransformers.filter { (transformer) -> Bool in
            transformer.team.contains("A")
        }
        
        eliminatedDecepticons = eliminatedTransformers.filter { (transformer) -> Bool in
            transformer.team.contains("D")
        }
        
        var winningTeamString = ""
        
        let winningAutoBots = winnerTransformers.filter { (transformer) -> Bool in
            transformer.team.contains("A")
        }
        
        let winningDecepticons = winnerTransformers.filter { (transformer) -> Bool in
            transformer.team.contains("D")
        }
        
        
        if eliminatedAutobots.count > eliminatedDecepticons.count {
            // Winner Team Decepticons
            let nameStringArray = winningDecepticons.compactMap({$0.name})
            let winners = nameStringArray.joined(separator: ", ")
            
            winningTeamString = "Winning team (Decepticons): " + winners
        } else {
            // Winner Team AutoBots
            let nameStringArray = winningAutoBots.compactMap({$0.name})
            let winners = nameStringArray.joined(separator: ", ")
            
            winningTeamString = "Winning team (Autobots): " + winners
        }
        
        return winningTeamString
        
    }
    
    private func survivorsString() -> String {
        var survivorsString = ""
        
        if eliminatedAutobots.count > eliminatedDecepticons.count {
            // Winner Team Decepticons
            let survivors = Array(Set(sortedAutobots).subtracting(eliminatedAutobots))
            let nameStringArray = survivors.compactMap({$0.name})
            let survivorNames = nameStringArray.joined(separator: ",")
            
            survivorsString = "Survivors from the losing team (Autobots): " + survivorNames
        } else {
            // Winner Team AutoBots
            let survivors = Array(Set(sortedDecepticons).subtracting(eliminatedDecepticons))
            let nameStringArray = survivors.compactMap({$0.name})
            let survivorNames = nameStringArray.joined(separator: ",")
            
            survivorsString = "Survivors from the losing team (Decepticons): " + survivorNames
        }
        
        return survivorsString
    }
    
    private func overallRating(transformer: Transformer) -> Int {
        let overallRating = transformer.strength + transformer.intelligence + transformer.speed + transformer.endurance + transformer.firepower
        return overallRating
    }
    
    private func calculateBattleCount(_ autoBots: [Transformer], _ decepticons: [Transformer]) -> Int {
        var battleCount = 0
        
        if autoBots.count == decepticons.count {
            battleCount = autoBots.count
        } else if autoBots.count < decepticons.count {
            battleCount = autoBots.count
        } else {
            battleCount = decepticons.count
        }
        
        return battleCount
    }

}
