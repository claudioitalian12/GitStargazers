//
//  StargazersView.swift
//  GitStargazers
//
//  Created by c331657 on 21/02/2021.
//  Copyright © 2021 c331657. All rights reserved.
//

import UIKit

class StargazersView: UIView {
    
    // MARK: - internal property
    
    var openErrorAlert: ((NetworkError) -> Void)?
    var stargazersViewModel: StargazersViewModel? {
        didSet {
            self.update()
        }
    }
    
    // MARK: - private property
    
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    private var stargazersTableView: UITableView = UITableView()
    
    init(viewModel: StargazersViewModel?) {
        super.init(frame: .zero)
        
        self.stargazersViewModel = viewModel
        self.setup()
        self.style()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate extension StargazersView {
    
    // MARK: - Setup
    
    private func setup() {
        self.refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        
        self.stargazersTableView.dataSource = self
        self.stargazersTableView.delegate = self
        self.stargazersTableView.register(UserViewCell.self, forCellReuseIdentifier: UserViewCell.reusableIdentifier)
        
        self.stargazersTableView.sendSubviewToBack(self.refreshControl)
        self.stargazersTableView.addSubview(self.refreshControl)
        self.addSubview(self.stargazersTableView)
    }
    
    // MARK: - Style
    
    private func style() {
        self.backgroundColor = .white
        
        self.refreshControl.tintColor = .gray
    }
    
    // MARK: - Layout
    
    private func layout() {
        self.stargazersTableView.translatesAutoresizingMaskIntoConstraints = false
        let usersTableViewConstraints = [
            self.stargazersTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.stargazersTableView.topAnchor.constraint(equalTo: self.topAnchor),
            self.stargazersTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.stargazersTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(usersTableViewConstraints)
    }
    
    // MARK: - Update
    
    func update() {
            self.stargazersViewModel?.getUsers(completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.updateTableView()
            case let .failure(error):
                self.openErrorAlert?(error)
            }
        })
    }
    
    // MARK: - UpdateTableView
    
    func updateTableView() {
        self.stargazersTableView.reloadData()
    }
}

@objc fileprivate extension StargazersView {
    func refresh(sender: AnyObject) {
        self.stargazersViewModel?.refreshUsers { [weak self] response in
            guard let self = self else { return }

            self.refreshControl.endRefreshing()

            switch response {
            case .success:
                self.updateTableView()
            case let .failure(error):
                self.openErrorAlert?(error)
            }
        }
    }
}

extension StargazersView: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        self.stargazersViewModel?.users.count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserViewCell.reusableIdentifier, for: indexPath) as? UserViewCell
        
        guard let viewModel = self.stargazersViewModel else { return UITableViewCell() }
        guard let userViewCell = cell else { return UITableViewCell() }
        
        let cellModel = UserViewCellModel(user: viewModel.users[indexPath.row], isInteractionEnable: false)
        userViewCell.cellModel = cellModel
        
        return userViewCell
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        self.stargazersViewModel?.loadMoreUsers(index: indexPath.row, completion: { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case .success:
                self.update()
            case let .failure(error):
                self.openErrorAlert?(error)
            }
        })
    }
}

extension StargazersView: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        120.0
    }
}
