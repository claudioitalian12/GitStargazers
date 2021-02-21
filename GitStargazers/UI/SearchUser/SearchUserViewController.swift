//
//  StargazersSearch.swift
//  GitStargazers
//
//  Created by c331657 on 19/02/2021.
//  Copyright © 2021 c331657. All rights reserved.
//

import UIKit

class SearchUserViewController: UIViewController {
    // MARK: - private property
    
    private let search: UISearchController = UISearchController(searchResultsController: nil)
    
    // MARK: - UIViewController method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupInteraction()
    }
    
    override func loadView() {
        let viewModel = SearchUserViewModel()
        self.view = SearchUserView(viewModel: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Users List"
        
        search.searchBar.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search a User"
        search.searchBar.searchTextField.backgroundColor = .white
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.searchController = search
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stargazer",
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(pushStargazerAlert))
    }
}

fileprivate extension SearchUserViewController {
    func setupInteraction() {
        guard let searchUserView = self.view as? SearchUserView else {
            return
        }
        
        searchUserView.openErrorAlert = { [weak self] error in
            guard let self = self else {
                return
            }
            self.showAlert(withTitle: NetworkError.alertError.rawValue, andMessage: error.rawValue)
        }
        
        searchUserView.didSelectCell = { [weak self] owner in
            guard let self = self else {
                return
            }
            let viewModel = RepositoryViewModel(owner: owner)
            let viewController = RepositoryUserViewController(viewModel: viewModel)
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

@objc fileprivate extension SearchUserViewController {
    func pushStargazerAlert(sender: UIBarButtonItem) {
        showStargazerAlert(completion: { [weak self] ownerName, repositoryName in
            guard let self = self else {
                return
            }
            
            let stargazersViewModel = StargazersViewModel(ownerName: ownerName, repositoryName: repositoryName)
            let stargazersViewController = StargazersViewController(viewModel: stargazersViewModel)
            
            self.navigationController?.pushViewController(stargazersViewController, animated: true)
        })
    }
}

extension SearchUserViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, let view = view as? SearchUserView else {
            return
        }
        
        view.searchUpdate(userName: text)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        guard let view = view as? SearchUserView else {
            return false
        }
        
        view.searchUserViewModel?.users = []
        view.update()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let view = view as? SearchUserView else {
            return
        }
        
        view.searchUpdate(userName: "")
    }
}
