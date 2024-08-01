//
//  ViewController.swift
//  StarWarsApp
//
//  Created by Israa Assem on 30/07/2024.
//

import UIKit
class CharactersViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var charactersTable: UITableView!
    private var charactersViewModel:CharactersViewModelProtocol?
    private let indicator=UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        charactersTable.delegate=self
        charactersTable.dataSource=self
        charactersTable.registerNib(cell: StarWarTableCell.self)
        view.addSubview(indicator)
        indicator.center=view.center
        indicator.startAnimating()
        charactersViewModel=CharactersViewModel(networkService: NetworkService.shared)
        charactersViewModel?.fetchCharacters()
        charactersViewModel?.bindCharactersToViewController={[weak self] in
            DispatchQueue.main.async{
                self?.indicator.stopAnimating()
                self?.charactersTable.reloadData()
            }
        }
    }


}
extension CharactersViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailsVc=storyboard?.instantiateViewController(withIdentifier: "detailsVC") as? CharacterDetailsViewController{
            let detailsViewModel=CharacterDetailsViewModel(character: charactersViewModel?.getCharactersArr()[indexPath.row],starship: nil,itemType: "character")
            detailsVc.characterDetailsViewModel=detailsViewModel
            detailsVc.modalPresentationStyle = .fullScreen
            self.present(detailsVc, animated: true)
        }

    }
}
extension CharactersViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        charactersViewModel?.getCharactersCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueNibCell(cellClass: StarWarTableCell.self)
        cell.nameLabel.text=charactersViewModel?.getCharactersArr()[indexPath.row].name
        return cell
    }
    
    
}
