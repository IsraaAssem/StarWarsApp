//
//  FavStarshipsViewController.swift
//  StarWarsApp
//
//  Created by Israa Assem on 02/08/2024.
//

import UIKit
import Lottie
class FavStarshipsViewController: UIViewController {
    @IBOutlet weak var favStarshipsTable: UITableView!
    var favStarshipsViewModel:FavStarshipsViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        favStarshipsTable.delegate=self
        favStarshipsTable.dataSource=self
        favStarshipsViewModel=FavStarshipsViewModel(favDao: FavStarWarsDao.shared)
        favStarshipsTable.registerNib(cell: StarWarTableCell.self)
        favStarshipsViewModel.retrieveStoredFavStarships()
    }

    @IBAction func dismissBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
extension FavStarshipsViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailsVc=storyboard?.instantiateViewController(withIdentifier: "detailsVC") as? CharacterDetailsViewController{
            let detailsViewModel=CharacterDetailsViewModel(character: nil, starship: favStarshipsViewModel?.getFavStarshipsArr()[indexPath.row],itemType: "starship")
            detailsVc.characterDetailsViewModel=detailsViewModel
            detailsVc.modalPresentationStyle = .fullScreen
            self.present(detailsVc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            let deleteAlert=UIAlertController(title: "Delete Character", message: "Are you sure you want to delete this character from favorites?", preferredStyle: UIAlertController.Style.alert)
            let deleteAction=UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { [weak self] _ in
                let starship = self?.favStarshipsViewModel?.getFavStarshipsArr()[indexPath.row ]
                self?.favStarshipsViewModel?.deleteFromFavStarships(starship: starship!)
                self?.favStarshipsTable.reloadData()
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
extension FavStarshipsViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if   favStarshipsViewModel.getFavStarshipsArrCount() == 0 {
            tableView.backgroundView=getBackgroundView(lottieName: "noResults", viewName: favStarshipsTable)
        }else{
            tableView.backgroundView=nil
        }
        return  favStarshipsViewModel.getFavStarshipsArrCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueNibCell(cellClass: StarWarTableCell.self)
        cell.nameLabel.text=favStarshipsViewModel.getFavStarshipsArr()[indexPath.row].name
        cell.delegate=self
        cell.favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        return cell
    }
    
}
extension FavStarshipsViewController:FavoriteButtonDelegate{
    func favoriteButtonTapped(in cell: StarWarTableCell,from button:UIButton) {
        
        let deleteAlert=UIAlertController(title: "Delete Character", message: "Are you sure you want to delete this character from favorites?", preferredStyle: UIAlertController.Style.alert)
        let deleteAction=UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { [weak self] _ in
            let indexPath = self?.favStarshipsTable.indexPath(for: cell)
            let starship = self?.favStarshipsViewModel?.getFavStarshipsArr()[indexPath?.row ?? 0]
            self?.favStarshipsViewModel?.deleteFromFavStarships(starship: starship!)
            self?.favStarshipsTable.reloadData()
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


