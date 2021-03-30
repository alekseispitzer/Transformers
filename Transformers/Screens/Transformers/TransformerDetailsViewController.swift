//
//  NewTransformerViewController.swift
//  Transformers
//
//  Created by Alek Spitzer on 3/27/21.
//

import UIKit

/// View type required to define the state of the TransformerDetailsViewController
enum ViewType {
    case newTransformer
    case updateTransformer
}

/// TransformerDetailsViewController: Used in order to create or update a transformer
class TransformerDetailsViewController: UIViewController, Storyboardable  {

    // MARK: - Storyboardable
    
    static var storyboardName: String {
        return "TransformersViewController"
    }
    
    // MARK: Handler
    
    var dismiss: (() -> Void)?
    
    
    // MARK: Properties
    
    var viewType: ViewType?
    var transformer: Transformer?
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var strenghtSlider: UISlider!
    @IBOutlet weak var strenghtValueLabel: UILabel!
    
    @IBOutlet weak var intelligenceSlider: UISlider!
    @IBOutlet weak var intelligenceValueLabel: UILabel!
    
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var speedValueLabel: UILabel!
    
    @IBOutlet weak var enduranceSlider: UISlider!
    @IBOutlet weak var enduranceValueLabel: UILabel!
    
    @IBOutlet weak var rankSlider: UISlider!
    @IBOutlet weak var rankValueLabel: UILabel!
    
    @IBOutlet weak var courageSlider: UISlider!
    @IBOutlet weak var courageValueLabel: UILabel!
    
    @IBOutlet weak var firepowerSlider: UISlider!
    @IBOutlet weak var firepowerValueLabel: UILabel!
    
    @IBOutlet weak var skillSlider: UISlider!
    @IBOutlet weak var skillValueLabel: UILabel!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewType == .newTransformer {
            title = "Add New Transformer"
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else if viewType == .updateTransformer {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: UIBarButtonItem.Style.plain, target: self, action: #selector(updateTapped))
            loadUI()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func loadUI() {
        guard let transformer = transformer else {
            return
        }
        
        title = transformer.name
        nameTextField.text = transformer.name
        
        strenghtSlider.value = Float(transformer.strength)
        strenghtValueLabel.text = String(transformer.strength)
        
        intelligenceSlider.value = Float(transformer.intelligence)
        intelligenceValueLabel.text = String(transformer.intelligence)
        
        speedSlider.value = Float(transformer.speed)
        speedValueLabel.text = String(transformer.speed)
        
        enduranceSlider.value = Float(transformer.endurance)
        enduranceValueLabel.text = String(transformer.endurance)
        
        rankSlider.value = Float(transformer.rank)
        rankValueLabel.text = String(transformer.rank)
        
        courageSlider.value = Float(transformer.courage)
        courageValueLabel.text = String(transformer.courage)
        
        firepowerSlider.value = Float(transformer.firepower)
        firepowerValueLabel.text = String(transformer.firepower)
        
        skillSlider.value = Float(transformer.skill)
        skillValueLabel.text = String(transformer.skill)
        
        segmentedControl.selectedSegmentIndex = transformer.team == "A" ? 0 : 1
    }
    
    @objc func saveTapped() {
        guard let name = nameTextField.text,
              let strength = strenghtValueLabel.text,
              let intelligence = intelligenceValueLabel.text,
              let speed = speedValueLabel.text,
              let endurance = enduranceValueLabel.text,
              let rank = rankValueLabel.text,
              let courage = courageValueLabel.text,
              let firepower = firepowerValueLabel.text,
              let skill = skillValueLabel.text else {
            return
        }
        
        var team = "A"
        if segmentedControl.selectedSegmentIndex == 1 {
            team = "D"
        }
        
        let transformer = Transformer(id: "0",
                                      name: name,
                                      strength: Int(strength)!,
                                      intelligence: Int(intelligence)!,
                                      speed: Int(speed)!,
                                      endurance: Int(endurance)!,
                                      rank: Int(rank)!,
                                      courage: Int(courage)!,
                                      firepower: Int(firepower)!,
                                      skill: Int(skill)!,
                                      team: team,
                                      teamIcon: "")
        
        TransformerService().createTransformer(transformer: transformer) { [weak self] (success) in
            guard let success = success else {
                return
            }
            
            if success {
                DispatchQueue.main.async {
                    self?.dismiss?()
                }
            }
        }
    }
    
    @objc func updateTapped() {
        guard let name = nameTextField.text,
              let strength = strenghtValueLabel.text,
              let intelligence = intelligenceValueLabel.text,
              let speed = speedValueLabel.text,
              let endurance = enduranceValueLabel.text,
              let rank = rankValueLabel.text,
              let courage = courageValueLabel.text,
              let firepower = firepowerValueLabel.text,
              let skill = skillValueLabel.text,
              let transformer = transformer else {
            return
        }
        
        var team = "A"
        if segmentedControl.selectedSegmentIndex == 1 {
            team = "D"
        }
        
        let updatedTransformer = Transformer(id: transformer.id,
                                      name: name,
                                      strength: Int(strength)!,
                                      intelligence: Int(intelligence)!,
                                      speed: Int(speed)!,
                                      endurance: Int(endurance)!,
                                      rank: Int(rank)!,
                                      courage: Int(courage)!,
                                      firepower: Int(firepower)!,
                                      skill: Int(skill)!,
                                      team: team,
                                      teamIcon: transformer.teamIcon)
        
        TransformerService().updateTransformer(transformer: updatedTransformer) { [weak self] (success) in
            guard let success = success else {
                return
            }
            
            if success {
                DispatchQueue.main.async {
                    self?.dismiss?()
                }
            }
        }
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        let newValue = Int(sender.value)
        sender.setValue(Float(newValue), animated: false)
        
        let stringValue = String(Int(sender.value))
        switch sender.tag {
        case 1:
            strenghtValueLabel.text = stringValue
        case 2:
            intelligenceValueLabel.text = stringValue
        case 3:
            speedValueLabel.text = stringValue
        case 4:
            enduranceValueLabel.text = stringValue
        case 5:
            rankValueLabel.text = stringValue
        case 6:
            courageValueLabel.text = stringValue
        case 7:
            firepowerValueLabel.text = stringValue
        case 8:
            skillValueLabel.text = stringValue
        default:
            break
        }
    }
}

// MARK: - UITextFieldDelegate

extension TransformerDetailsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
        
        if viewType == .newTransformer {
            navigationItem.rightBarButtonItem?.isEnabled =  newString.length > 0 ? true : false
        }
        
        return true
    }
}
