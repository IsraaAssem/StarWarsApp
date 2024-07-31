//
//  StarshipsViewController.swift
//  StarWarsApp
//
//  Created by Israa Assem on 30/07/2024.
//

import UIKit
import Lottie
class StarshipsViewController: UIViewController {
    
    @IBOutlet weak var starshipsTable: UITableView!
    private let loadingIndicator=UIActivityIndicatorView(style: .large)
    private var starshipsViewModel:StarshipsViewModelProtocol?=nil
    override func viewDidLoad() {
        super.viewDidLoad()
        starshipsTable.registerNib(cell: StarWarTableCell.self)
        starshipsTable.delegate=self
        starshipsTable.dataSource=self
        self.title="Starships"
        starshipsViewModel=StarshipsViewModel(networkService: NetworkService.shared)
        loadingIndicator.center=view.center
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        starshipsViewModel?.fetchStarships()
        starshipsViewModel?.bindStarshipsToViewController = { [weak self] in
            DispatchQueue.main.async{
                self?.loadingIndicator.stopAnimating()
                self?.starshipsTable.reloadData()
            }
        }
    }
    
}
extension StarshipsViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailsVc=storyboard?.instantiateViewController(identifier: "detailsVC") as? CharacterDetailsViewController{
            let detailsViewModel=CharacterDetailsViewModel(character: nil, starship: starshipsViewModel?.getStarships()[indexPath.row], itemType: "starship")
            detailsVc.characterDetailsViewModel=detailsViewModel
            detailsVc.modalPresentationStyle = .fullScreen
            present(detailsVc, animated: true)
        }
    }
   
}
extension StarshipsViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        starshipsViewModel?.getStarshipsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueNibCell(cellClass: StarWarTableCell.self) 
        cell.nameLabel.text=starshipsViewModel?.getStarships()[indexPath.row].name
        return cell
    }
    
    
}
