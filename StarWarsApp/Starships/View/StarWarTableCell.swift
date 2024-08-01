//
//  StarWarTableCell.swift
//  StarWarsApp
//
//  Created by Israa Assem on 30/07/2024.
//

import UIKit

class StarWarTableCell: UITableViewCell {

    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView!
    weak var delegate: FavoriteButtonDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellBackgroundView.layer.cornerRadius=10
        self.cellBackgroundView.layer.borderColor=UIColor(named: "MainColor")?.cgColor
        self.cellBackgroundView.layer.borderWidth=1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    static var screenName:String="Characters"
    
    @IBAction func favBtnPressed(_ sender: UIButton) {
        print(StarWarTableCell.screenName)
        delegate?.favoriteButtonTapped(in: self,from:sender)
    }
    
}
protocol FavoriteButtonDelegate: AnyObject {
    func favoriteButtonTapped(in cell: StarWarTableCell,from button:UIButton)
}
