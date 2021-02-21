//
//  SearchUserView.swift
//  GitStargazers
//
//  Created by c331657 on 19/02/2021.
//  Copyright © 2021 c331657. All rights reserved.
//

import UIKit

class SearchUserView: UIView {
    
    // MARK: - internal property
    
    var openErrorAlert: ((NetworkError) -> Void)?
    var didSelectCell: ((String) -> Void)?
    var searchUserViewModel: SearchUserViewModel? {
        didSet {
            self.update()
        }
    }
    
    // MARK: - private property
    
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    private var usersTableView: UITableView = UITableView()
    
    init(viewModel: SearchUserViewModel?) {
        super.init(frame: .zero)
        
        self.searchUserViewModel = viewModel
        self.setup()
        self.style()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func searchUpdate(userName: String) {
        if userName.isEmpty {
            self.refresh(sender: self.refreshControl)
            self.searchUserViewModel?.setSearchingStatus(status: false)
            return
        } else {
            self.searchUserViewModel?.setSearchingStatus(status: true)
        }
        
        self.searchUserViewModel?.loadSearchUser(searchUserName: userName, completion: {[weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success:
                self.update()
            case .failure:
                self.openErrorAlert?(NetworkError.maxNumberOfSearch)
            }
        })
    }
    
    func update() {
        guard let viewModel = self.searchUserViewModel else {
            return
        }
        
        self.usersTableView.isHidden = viewModel.usersIsEmpty
        self.usersTableView.reloadData()
    }
}

fileprivate extension SearchUserView {
    
    // MARK: - Setup
    
    func setup() {
        self.refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        
        self.usersTableView.dataSource = self
        self.usersTableView.delegate = self
        self.usersTableView.register(UserViewCell.self, forCellReuseIdentifier: UserViewCell.reusableIdentifier)
        
        self.usersTableView.sendSubviewToBack(self.refreshControl)
        self.usersTableView.addSubview(self.refreshControl)
        self.addSubview(self.usersTableView)
        
        self.searchUserViewModel?.getUsers(completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.update()
            case let .failure(error):
                self.openErrorAlert?(error)
            }
        })
    }
    
    // MARK: - Style
    
    func style() {
        self.backgroundColor = .white
        self.usersTableView.isHidden = true
        self.refreshControl.tintColor = .gray
    }
    
    // MARK: - Layout
    
    func layout() {
        self.usersTableView.translatesAutoresizingMaskIntoConstraints = false
        let usersTableViewConstraints = [
            self.usersTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.usersTableView.topAnchor.constraint(equalTo: self.topAnchor),
            self.usersTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.usersTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(usersTableViewConstraints)
    }
}

@objc fileprivate extension SearchUserView {
    func refresh(sender: AnyObject) {
        self.searchUserViewModel?.refreshUsers { [weak self] response in
            guard let self = self else {
                return
            }
            self.refreshControl.endRefreshing()
            switch response {
            case .success:
                self.update()
            case let .failure(error):
                self.openErrorAlert?(error)
            }
        }
    }
}

extension SearchUserView: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.searchUserViewModel?.users.count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserViewCell.reusableIdentifier, for: indexPath) as? UserViewCell
        
        guard let viewModel = self.searchUserViewModel else {
            return UITableViewCell()
        }
        guard let userViewCell = cell else {
            return UITableViewCell()
        }
        let cellModel = UserViewCellModel(user: viewModel.users[indexPath.row], accessoryType: .disclosureIndicator)
        userViewCell.cellModel = cellModel
        
        return userViewCell
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        self.searchUserViewModel?.loadMoreUsers(index: indexPath.row, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            
            switch response {
            case .success:
                self.update()
            case let .failure(error):
                self.openErrorAlert?(error)
            }
        })
    }
}

extension SearchUserView: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        120.0
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath)  as? UserViewCell else {
            return
        }
        
        self.didSelectCell?(cell.cellModel?.user.userName ?? "")
    }
}
