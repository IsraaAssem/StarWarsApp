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
    }
    override func viewWillAppear(_ animated: Bool) {
        StarWarTableCell.screenName="Starships"
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
        return cell
    }
    
    
}
extension StarshipsViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText=searchText
    }
}
