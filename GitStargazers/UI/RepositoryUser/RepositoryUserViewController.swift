//
//  RepositoryUserViewController.swift
//  GitStargazers
//
//  Created by c331657 on 20/02/2021.
//  Copyright © 2021 c331657. All rights reserved.
//

import UIKit

class RepositoryUserViewController: UIViewController {
    
    // MARK: - private property
    
    private var viewModel: RepositoryViewModel?
    
    // MARK: - UIViewController method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        self.setupInteraction()
    }
    
    override func loadView() {
        self.view = RepositoryView(viewModel: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Repository"
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stargazer",
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(pushStargazerAlert))
    }
    
    // MARK: - init
    
    init(viewModel: RepositoryViewModel) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate extension RepositoryUserViewController {
    
    // MARK: - Setup
    
    func setup() {
        guard let view = self.view as? RepositoryView else {
            return
        }
        
        view.repositoryViewModel = viewModel
    }
    
    // MARK: - SetupInteraction
    
    func setupInteraction() {
        guard let repositoryView = self.view as? RepositoryView else {
            return
        }
        
        repositoryView.openErrorAlert = { [weak self] error in
            guard let self = self else {
                return
            }
            self.showAlert(withTitle: NetworkError.alertError.rawValue, andMessage: error.rawValue)
        }
        
        repositoryView.didSelectCell = { [weak self] repositoryName, owner in
            guard let self = self else {
                return
            }
            
            self.pushStargazers(repositoryName: repositoryName, owner: owner)
        }
    }
    
    // MARK: - PushStargazers ViewController
    
    func pushStargazers(repositoryName: String, owner: String) {
        let stargazersViewModel = StargazersViewModel(ownerName: owner, repositoryName: repositoryName)
        let stargazersViewController = StargazersViewController(viewModel: stargazersViewModel)
        
        self.navigationController?.pushViewController(stargazersViewController, animated: true)
    }
}

@objc fileprivate extension RepositoryUserViewController {
    func pushStargazerAlert(sender: UIBarButtonItem) {
        showStargazerAlert(ownerName: viewModel?.owner ?? "", completion: { [weak self] ownerName, repositoryName in
            guard let self = self else {
                return
            }
            
            self.pushStargazers(repositoryName: repositoryName, owner: ownerName)
        })
    }
}
