//
//  ViewController.swift
//  StarWarsApp
//
//  Created by Israa Assem on 30/07/2024.
//

import UIKit
import Combine
class CharactersViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var charactersTable: UITableView!
    private var charactersViewModel:CharactersViewModelProtocol?
    private let indicator=UIActivityIndicatorView(style: .large)
    @Published var searchText=""
    private var isLoading=true
    var cancellables = Set<AnyCancellable>()
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
        charactersViewModel?.fetchCharacters()
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
    }

    override func viewWillAppear(_ animated: Bool) {
        StarWarTableCell.screenName="Characters"
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
            //button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
    
    
}
