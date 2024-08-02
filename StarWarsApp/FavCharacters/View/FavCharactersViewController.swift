//
//  FavCharactersViewController.swift
//  StarWarsApp
//
//  Created by Israa Assem on 02/08/2024.
//

import Foundation
import UIKit
import Lottie
class FavCharactersViewController:UIViewController{
    
    @IBOutlet weak var favCharactersTable: UITableView!
    var favCharactersViewModel:FavCharactersViewModelProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        favCharactersViewModel=FavCharactersViewModel(favDao: FavStarWarsDao.shared)
        favCharactersTable.registerNib(cell: StarWarTableCell.self)
        favCharactersTable.dataSource=self
        favCharactersTable.delegate=self
        favCharactersViewModel.retrieveStoredFavCharacters()
    }
    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
extension FavCharactersViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if   favCharactersViewModel.getFavCharactersArrCount() == 0 {
            tableView.backgroundView=getBackgroundView(lottieName: "noResults", viewName: favCharactersTable)
        }else{
            tableView.backgroundView=nil
        }
        return  favCharactersViewModel.getFavCharactersArrCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueNibCell(cellClass: StarWarTableCell.self)
        cell.nameLabel.text=favCharactersViewModel.getFavCharactersArr()[indexPath.row].name
        cell.delegate=self
        cell.favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        return cell
    }
    
    
}
extension FavCharactersViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailsVc=storyboard?.instantiateViewController(withIdentifier: "detailsVC") as? CharacterDetailsViewController{
            let detailsViewModel=CharacterDetailsViewModel(character: favCharactersViewModel?.getFavCharactersArr()[indexPath.row],starship: nil,itemType: "character")
            detailsVc.characterDetailsViewModel=detailsViewModel
            detailsVc.modalPresentationStyle = .fullScreen
            self.present(detailsVc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            let deleteAlert=UIAlertController(title: "Delete Character", message: "Are you sure you want to delete this character from favorites?", preferredStyle: UIAlertController.Style.alert)
            let deleteAction=UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { [weak self] _ in
                let character = self?.favCharactersViewModel?.getFavCharactersArr()[indexPath.row ]
                self?.favCharactersViewModel?.deleteFromFavCharacters(character: character!)
                self?.favCharactersTable.reloadData()
                let animationView = LottieAnimationView(name: "delete")
                self?.view.addSubview(animationView)
                animationView.contentMode = .scaleAspectFit
                animationView.frame.size=CGSize(width: (self?.view.frame.width ?? 400)/2 , height: (self?.view.frame.width ?? 400)/2 )
                animationView.center = (self?.view.center)!
                animationView.play()
                Timer.scheduledTimer(withTimeInterval: 1.25, repeats: false) { _ in
                    animationView.removeFromSuperview()
                }
            })
            let cancelAction=UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
            deleteAlert.addAction(deleteAction)
            deleteAlert.addAction(cancelAction)
            self?.present(deleteAlert, animated: true, completion: nil)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
}
extension FavCharactersViewController:FavoriteButtonDelegate{
    func favoriteButtonTapped(in cell: StarWarTableCell,from button:UIButton) {
        
        let deleteAlert=UIAlertController(title: "Delete Character", message: "Are you sure you want to delete this character from favorites?", preferredStyle: UIAlertController.Style.alert)
        let deleteAction=UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { [weak self] _ in
            let indexPath = self?.favCharactersTable.indexPath(for: cell)
            let character = self?.favCharactersViewModel?.getFavCharactersArr()[indexPath?.row ?? 0]
            self?.favCharactersViewModel?.deleteFromFavCharacters(character: character!)
            self?.favCharactersTable.reloadData()
            let animationView = LottieAnimationView(name: "delete")
            self?.view.addSubview(animationView)
            animationView.contentMode = .scaleAspectFit
            animationView.frame.size=CGSize(width: (self?.view.frame.width ?? 400)/2 , height: (self?.view.frame.width ?? 400)/2 )
            animationView.center = (self?.view.center)!
            animationView.play()
            Timer.scheduledTimer(withTimeInterval: 1.25, repeats: false) { _ in
                animationView.removeFromSuperview()
            }
        })
        let cancelAction=UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(cancelAction)
        self.present(deleteAlert, animated: true, completion: nil)
        
    }
}


