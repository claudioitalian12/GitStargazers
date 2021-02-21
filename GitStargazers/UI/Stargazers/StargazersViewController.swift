//
//  StargazersViewController.swift
//  GitStargazers
//
//  Created by c331657 on 21/02/2021.
//  Copyright © 2021 c331657. All rights reserved.
//

import UIKit

class StargazersViewController: UIViewController {
    
    // MARK: - private property
    
    private var viewModel: StargazersViewModel?
    
    // MARK: - UIViewController method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        self.setupInteraction()
    }
    
    override func loadView() {
        self.view = StargazersView(viewModel: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Stargazers"
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - init
    
    init(viewModel: StargazersViewModel) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate extension StargazersViewController {
    
    // MARK: - Setup
    
    func setup() {
        guard let view = self.view as? StargazersView else {
            return
        }
        
        view.stargazersViewModel = viewModel
    }
    
    // MARK: - SetupInteraction
    
    func setupInteraction() {
        guard let stargazersView = self.view as? StargazersView else { return }
        
        stargazersView.openErrorAlert = { [weak self] error in
            guard let self = self else { return }
            self.showAlert(withTitle: NetworkError.alertError.rawValue, andMessage: error.rawValue)
        }
    }
}
