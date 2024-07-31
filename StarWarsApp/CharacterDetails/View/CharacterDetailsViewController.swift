//
//  CharacterDetailsViewController.swift
//  StarWarsApp
//
//  Created by Israa Assem on 30/07/2024.
//

import UIKit

class CharacterDetailsViewController: UIViewController {
    @IBOutlet weak var characterName: UILabel!
    var characterDetailsViewModel:CharacterDetailsViewModelProtocol?=nil
    override func viewDidLoad() {
        super.viewDidLoad()
        characterName.text=characterDetailsViewModel?.getCharacter()?.name
    }

}
