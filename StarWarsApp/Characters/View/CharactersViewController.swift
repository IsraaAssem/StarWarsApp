//
//  ViewController.swift
//  StarWarsApp
//
//  Created by Israa Assem on 30/07/2024.
//

import UIKit
import Combine
import Lottie
import Network
class CharactersViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var charactersTable: UITableView!
    private var charactersViewModel:CharactersViewModelProtocol?
    private let indicator=UIActivityIndicatorView(style: .large)
    @Published var searchText=""
    private var isLoading=true
    var cancellables = Set<AnyCancellable>()
    var favCharactersViewModel:FavCharactersViewModelProtocol!
    private let animationView = LottieAnimationView(name: "noInternet")
    private let monitor = NWPathMonitor()
    override func viewDidLoad() {
        super.viewDidLoad()
        charactersTable.delegate=self
        charactersTable.dataSource=self
        searchBar.delegate=self
        charactersTable.registerNib(cell: StarWarTableCell.self)
        view.addSubview(indicator)
        indicator.center=view.center
        indicator.startAnimating()
        charactersViewModel=CharactersViewModel(networkService: NetworkService.shared)
        charactersViewModel?.fetchCharacters(pageNumber: charactersViewModel?.getCurrentPage() ?? 1)
        charactersViewModel?.bindCharactersToViewController={[weak self] in
            DispatchQueue.main.async{
                self?.indicator.stopAnimating()
                self?.charactersTable.reloadData()
                self?.isLoading=false
            }
        }
        charactersViewModel?.updateTable={[weak self] in
            self?.charactersTable.reloadData()
        }
        $searchText.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] debouncedSearchText in
                self?.charactersViewModel?.filterCharacters(by:debouncedSearchText)
            }.store(in: &cancellables)
        favCharactersViewModel=FavCharactersViewModel(favDao: FavStarWarsDao.shared)
        favCharactersViewModel.retrieveStoredFavCharacters()
        animationView.frame = view.bounds
        animationView.frame.size=CGSize(width: view.frame.size.width*0.75, height: view.frame.size.width*0.75)
        animationView.contentMode = .scaleAspectFit
        animationView.center = view.center

        animationView.loopMode = .loop
        view.addSubview(animationView)
        
        monitor.start(queue: DispatchQueue.global())
        monitor.pathUpdateHandler = {[weak self] path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self?.animationView.removeFromSuperview()
                    if self?.isLoading == true{
                        self?.charactersViewModel?.fetchCharacters(pageNumber: self?.charactersViewModel?.getCurrentPage() ?? 1)
                    }
                } else {
                    if let self=self{
                        self.view.addSubview(self.animationView)
                    }
                    self?.animationView.play()
                }
            }
        }
    }

    @IBAction func allFavCharactersBtnPressed(_ sender: Any) {
        let storyboard=UIStoryboard(name: "Main", bundle: nil)
        let favCharactersVC=storyboard.instantiateViewController(withIdentifier: "favCharactersVC")
        favCharactersVC.modalPresentationStyle = .fullScreen
        self.present(favCharactersVC, animated: true)
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (charactersViewModel?.getCharactersCount() ?? 0) - 1 && !isLoading {
            charactersViewModel?.fetchCharacters(pageNumber: (charactersViewModel?.getCurrentPage() ?? 1) + 1)
               }
    }
}

extension CharactersViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if charactersViewModel?.getCharactersCount() == 0 && isLoading==false{
            tableView.backgroundView=getBackgroundView(lottieName: "noResults", viewName: charactersTable)
        }else{
            tableView.backgroundView=nil
        }
        return charactersViewModel?.getCharactersCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueNibCell(cellClass: StarWarTableCell.self)
        cell.nameLabel.text=charactersViewModel?.getCharactersArr()[indexPath.row].name
        cell.delegate=self
        if favCharactersViewModel.getFavCharactersArr().contains(where: { [weak self]character in
            character.url == self?.charactersViewModel?.getCharactersArr()[indexPath.row].url}){
            cell.favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            
        }else{
            cell.favButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
            
        }
        return cell
    }
}
extension CharactersViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText=searchText
    }
}
extension CharactersViewController:FavoriteButtonDelegate{
    func favoriteButtonTapped(in cell: StarWarTableCell,from button:UIButton) {
        if let cellIndex=charactersTable.indexPath(for: cell)?.row{
            print(charactersViewModel?.getCharactersArr()[cellIndex].name ?? "N/A")
            if favCharactersViewModel.getFavCharactersArr().contains(where: { [weak self]character in
                character.url == self?.charactersViewModel?.getCharactersArr()[cellIndex].url
            }){
                let deleteAlert=UIAlertController(title: "Delete Character", message: "Are you sure you want to delete this character from favorites?", preferredStyle: UIAlertController.Style.alert)
                let deleteAction=UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { [weak self] _ in
                    self?.favCharactersViewModel.deleteFromFavCharacters(character: (self?.charactersViewModel?.getCharactersArr()[cellIndex])!)
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
                favCharactersViewModel.addCharacterToFav(character: (charactersViewModel?.getCharactersArr()[cellIndex])!)
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
