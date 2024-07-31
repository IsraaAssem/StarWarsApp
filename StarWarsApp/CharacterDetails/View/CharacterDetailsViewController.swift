//
//  CharacterDetailsViewController.swift
//  StarWarsApp
//
//  Created by Israa Assem on 30/07/2024.
//

import UIKit

class CharacterDetailsViewController: UIViewController {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var gender_modelValue: UILabel!
    @IBOutlet weak var gender_modelKey: UILabel!
    @IBOutlet weak var height_manufacturerKey: UILabel!
    @IBOutlet weak var height_manufacturerValue: UILabel!
    
    @IBOutlet weak var eyeColor_costKey: UILabel!
    @IBOutlet weak var eyeColor_costValue: UILabel!
    
    @IBOutlet weak var skinColor_passengersKey: UILabel!
    
    @IBOutlet weak var skinColor_passengersValue: UILabel!
    
    @IBOutlet weak var birthYear_crewKey: UILabel!
    
    @IBOutlet weak var birthYear_crewValue: UILabel!
    
    var characterDetailsViewModel:CharacterDetailsViewModelProtocol?=nil
    override func viewDidLoad() {
        super.viewDidLoad()
        if characterDetailsViewModel?.getItemType()=="character"{
            handleCharacterDetails()
        }else{
            handleStarshipDetails()
        }
    }
    
    private func handleCharacterDetails(){
        screenTitle.text="Character Details"
        name.text=characterDetailsViewModel?.getCharacter()?.name
        gender_modelValue.text=characterDetailsViewModel?.getCharacter()?.gender
        height_manufacturerValue.text=characterDetailsViewModel?.getCharacter()?.height
        eyeColor_costValue.text=characterDetailsViewModel?.getCharacter()?.eyeColor
        skinColor_passengersValue.text=characterDetailsViewModel?.getCharacter()?.skinColor
        birthYear_crewValue.text=characterDetailsViewModel?.getCharacter()?.birthYear
        
    }
    private func handleStarshipDetails(){
        screenTitle.text="Starship Details"
        gender_modelKey.text="Model"
        height_manufacturerKey.text="Manufacturer"
        eyeColor_costKey.text="Cost in credits"
        skinColor_passengersKey.text="Passengers"
        birthYear_crewKey.text="Crew"
        name.text=characterDetailsViewModel?.getStarship()?.name
        gender_modelValue.text=characterDetailsViewModel?.getStarship()?.model
        height_manufacturerValue.text=characterDetailsViewModel?.getStarship()?.manufacturer
        eyeColor_costValue.text=characterDetailsViewModel?.getStarship()?.costInCredits
        skinColor_passengersValue.text=characterDetailsViewModel?.getStarship()?.passengers
        birthYear_crewValue.text=characterDetailsViewModel?.getStarship()?.crew
        
    }
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }

}
