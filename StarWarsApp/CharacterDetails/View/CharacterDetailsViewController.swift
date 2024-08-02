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
        let gender = characterDetailsViewModel?.getCharacter()?.gender?.lowercased()
        if gender == "unknown" || gender == "n/a"{
            gender_modelValue.text="Not Available"
            gender_modelValue.textColor = .red
        }else{
            gender_modelValue.text=characterDetailsViewModel?.getCharacter()?.gender
        }
        let height = characterDetailsViewModel?.getCharacter()?.height?.lowercased()
        if height == "unknown" || height == "n/a"{
            height_manufacturerValue.text="Not Available"
            height_manufacturerValue.textColor = .red
        }else{
            height_manufacturerValue.text=characterDetailsViewModel?.getCharacter()?.height
        }
        let eyeColor = characterDetailsViewModel?.getCharacter()?.eyeColor?.lowercased()
        if eyeColor == "unknown" || eyeColor == "n/a"{
            eyeColor_costValue.text="Not Available"
            eyeColor_costValue.textColor = .red
        }else{
            eyeColor_costValue.text=characterDetailsViewModel?.getCharacter()?.eyeColor
        }
        let skinColor = characterDetailsViewModel?.getCharacter()?.skinColor?.lowercased()
        if skinColor == "unknown" || skinColor == "n/a"{
            skinColor_passengersValue.text="Not Available"
            skinColor_passengersValue.textColor = .red
        }else{
            skinColor_passengersValue.text=characterDetailsViewModel?.getCharacter()?.skinColor
        }
        let birthYear = characterDetailsViewModel?.getCharacter()?.birthYear?.lowercased()
        if birthYear == "unknown" || birthYear == "n/a"{
            birthYear_crewValue.text="Not Available"
            birthYear_crewValue.textColor = .red
        }else{
            birthYear_crewValue.text=characterDetailsViewModel?.getCharacter()?.birthYear
        }
        
    }
    private func handleStarshipDetails(){
        screenTitle.text="Starship Details:"
        gender_modelKey.text="Model:"
        height_manufacturerKey.text="Manufacturer:"
        eyeColor_costKey.text="Cost in credits:"
        skinColor_passengersKey.text="Passengers:"
        birthYear_crewKey.text="Crew:"
        name.text=characterDetailsViewModel?.getStarship()?.name
        let model = characterDetailsViewModel?.getStarship()?.model?.lowercased()
        if model == "unknown" || model == "n/a"{
            gender_modelValue.text="Not Available"
            gender_modelValue.textColor = .red
        }else{
            gender_modelValue.text=characterDetailsViewModel?.getStarship()?.model
        }
        let manufacturer = characterDetailsViewModel?.getStarship()?.manufacturer?.lowercased()
        if manufacturer == "unknown" || manufacturer == "n/a"{
            height_manufacturerValue.text="Not Available"
            height_manufacturerValue.textColor = .red
        }else{
            height_manufacturerValue.text=characterDetailsViewModel?.getStarship()?.manufacturer
        }
        let cost = characterDetailsViewModel?.getStarship()?.costInCredits?.lowercased()
        if cost == "unknown" || cost == "n/a"{
            eyeColor_costValue.text="Not Available"
            eyeColor_costValue.textColor = .red
        }else{
            eyeColor_costValue.text=characterDetailsViewModel?.getStarship()?.costInCredits
        }
        let passengers = characterDetailsViewModel?.getStarship()?.passengers?.lowercased()
        if passengers == "unknown" || passengers == "n/a"{
            skinColor_passengersValue.text="Not Available"
            skinColor_passengersValue.textColor = .red
        }else{
            skinColor_passengersValue.text=characterDetailsViewModel?.getStarship()?.passengers
        }
        let crew = characterDetailsViewModel?.getStarship()?.crew?.lowercased()
        if crew == "unknown" || crew == "n/a"{
            birthYear_crewValue.text="Not Available"
            birthYear_crewValue.textColor = .red
        }else{
            birthYear_crewValue.text=characterDetailsViewModel?.getStarship()?.crew
        }
        
    }
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }

}
