//
//  TransformerCell.swift
//  Transformers
//
//  Created by Alek Spitzer on 3/28/21.
//

import UIKit
import AlamofireImage

class TransformerCell: UITableViewCell {

    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var strengthValueLabel: UILabel!
    @IBOutlet weak var intelligenceValueLabel: UILabel!
    @IBOutlet weak var speedValueLabel: UILabel!
    @IBOutlet weak var enduranceValueLabel: UILabel!
    @IBOutlet weak var rankValueLabel: UILabel!
    @IBOutlet weak var courageValueLabel: UILabel!
    @IBOutlet weak var firepowerValueLabel: UILabel!
    @IBOutlet weak var skillValueLabel: UILabel!
    
    @IBOutlet weak var overallRatingValueLabel: UILabel!
    
    
    func setup(transformer: Transformer) {
        nameLabel.text = transformer.name
        strengthValueLabel.text = String(transformer.strength)
        intelligenceValueLabel.text = String(transformer.intelligence)
        speedValueLabel.text = String(transformer.speed)
        enduranceValueLabel.text = String(transformer.endurance)
        rankValueLabel.text = String(transformer.rank)
        courageValueLabel.text = String(transformer.courage)
        firepowerValueLabel.text = String(transformer.firepower)
        skillValueLabel.text = String(transformer.skill)
        
        let overallRating = transformer.strength + transformer.intelligence + transformer.speed + transformer.endurance + transformer.firepower
        
        if let teamIconUrl = URL(string: transformer.teamIcon) {
            teamImageView.af.setImage(withURL: teamIconUrl)
        }
        
        
        overallRatingValueLabel.text = String(overallRating)
    }
}
