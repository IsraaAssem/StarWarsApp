//
//  StarshipsViewController.swift
//  StarWarsApp
//
//  Created by Israa Assem on 30/07/2024.
//

import UIKit
import Lottie
import Combine
class StarshipsViewController: UIViewController {
    
    @IBOutlet weak var starshipsTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private let loadingIndicator=UIActivityIndicatorView(style: .large)
    private var starshipsViewModel:StarshipsViewModelProtocol?=nil
    @Published var searchText=""
    var cancellables = Set<AnyCancellable>()
    private var isLoading=true
    var favStarshipsViewModel:FavStarshipsViewModelProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        starshipsTable.registerNib(cell: StarWarTableCell.self)
        starshipsTable.delegate=self
        starshipsTable.dataSource=self
        searchBar.delegate=self
        self.title="Starships"
        starshipsViewModel=StarshipsViewModel(networkService: NetworkService.shared)
        loadingIndicator.center=view.center
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        starshipsViewModel?.fetchStarships()
        $searchText.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] debouncedSearchText in
                self?.starshipsViewModel?.filterStarships(by:debouncedSearchText)
            }.store(in: &cancellables)
        starshipsViewModel?.bindStarshipsToViewController = { [weak self] in
            DispatchQueue.main.async{
                self?.loadingIndicator.stopAnimating()
                self?.starshipsTable.reloadData()
                self?.isLoading=false
            }
        }
        starshipsViewModel?.updateTable={[weak self] in
            self?.starshipsTable.reloadData()
        }
        favStarshipsViewModel=FavStarshipsViewModel(favDao: FavStarWarsDao.shared)
        favStarshipsViewModel.retrieveStoredFavStarships()
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
        if starshipsViewModel?.getStarshipsCount() == 0 && isLoading==false{
            tableView.backgroundView=getBackgroundView(lottieName: "noResults", viewName: starshipsTable)
        }else{
            tableView.backgroundView=nil
        }
        return starshipsViewModel?.getStarshipsCount() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueNibCell(cellClass: StarWarTableCell.self) 
        cell.nameLabel.text=starshipsViewModel?.getStarships()[indexPath.row].name
        cell.delegate=self
        if favStarshipsViewModel.getFavStarshipsArr().contains(where: { [weak self]starship in
            starship.url == self?.starshipsViewModel?.getStarships()[indexPath.row].url}){
                cell.favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)

            }else{
                cell.favButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)

            }
        return cell
    }
    
    
}
extension StarshipsViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText=searchText
    }
}
extension StarshipsViewController:FavoriteButtonDelegate{
    func favoriteButtonTapped(in cell: StarWarTableCell,from button:UIButton) {
        if let cellIndex=starshipsTable.indexPath(for: cell)?.row{
            if favStarshipsViewModel.getFavStarshipsArr().contains(where: { [weak self]starship in
                starship.url == self?.starshipsViewModel?.getStarships()[cellIndex].url
            }){
                let deleteAlert=UIAlertController(title: "Delete Starship", message: "Are you sure you want to delete this starship from favorites?", preferredStyle: UIAlertController.Style.alert)
                let deleteAction=UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { [weak self] _ in
                    self?.favStarshipsViewModel.deleteFromFavStarships(starship: (self?.starshipsViewModel?.getStarships()[cellIndex])!)
                    button.setImage(UIImage(systemName: "suit.heart"), for: .normal)
                    
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
            }else{
                favStarshipsViewModel.addStarshipToFav(starship: (starshipsViewModel?.getStarships()[cellIndex])!)
                button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                let animationView = LottieAnimationView(name: "heart")
                self.view.addSubview(animationView)
                animationView.contentMode = .scaleAspectFill
                animationView.frame.size=CGSize(width: view.frame.width, height: view.frame.width)
                animationView.center = self.view.center
                animationView.play()
                Timer.scheduledTimer(withTimeInterval: 1.25, repeats: false) { _ in
                    animationView.removeFromSuperview()
                }
            }
        }
    }
    
    
}
