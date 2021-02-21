//
//  RepositoryView.swift
//  GitStargazers
//
//  Created by c331657 on 20/02/2021.
//  Copyright © 2021 c331657. All rights reserved.
//

import UIKit

class RepositoryView: UIView {
    
    // MARK: - internal property
    
    var openErrorAlert: ((NetworkError) -> Void)?
    var didSelectCell: ((String, String) -> Void)?
    var repositoryViewModel: RepositoryViewModel? {
        didSet {
            self.update()
        }
    }
    
    // MARK: - private property
    
    private var repositoryCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    init(viewModel: RepositoryViewModel?) {
        super.init(frame: .zero)
        
        self.repositoryViewModel = viewModel
        self.setup()
        self.style()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate extension RepositoryView {
    
    // MARK: - Setup
    
    func setup() {
        self.repositoryCollectionView.dataSource = self
        self.repositoryCollectionView.delegate = self

        self.repositoryCollectionView.register(RepositoryCell.self, forCellWithReuseIdentifier: RepositoryCell.reusableIdentifier)
        self.repositoryCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "default")
        
        self.addSubview(self.repositoryCollectionView)
    }
    
    // MARK: - Style
    
    func style() {
        self.backgroundColor = .white
        self.repositoryCollectionView.isHidden = true
        self.repositoryCollectionView.backgroundColor = .white
    }
    
    // MARK: - Layout
    
    func layout() {
        self.repositoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        let repositoryCollectionViewConstraints = [
            self.repositoryCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.repositoryCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            self.repositoryCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.repositoryCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(repositoryCollectionViewConstraints)
    }
    
    // MARK: - Update
    
    func update() {
        self.repositoryViewModel?.loadRepository(completion: { [weak self] result in
            guard let self = self else {
                return
            }
            guard let viewModel = self.repositoryViewModel else {
                return
            }
            switch result {
            case .success:
                self.repositoryCollectionView.reloadData()
                self.repositoryCollectionView.isHidden = viewModel.usersIsEmpty
            case let .failure(error):
                self.openErrorAlert?(error)
            }
        })
    }
}

extension RepositoryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.repositoryViewModel?.repository.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepositoryCell.reusableIdentifier, for: indexPath) as? RepositoryCell
        
        guard let viewModel = self.repositoryViewModel else {
            return UICollectionViewCell()
        }
        guard let repositoryViewCell = cell else {
            return UICollectionViewCell()
        }
        let cellModel = RepositoryCellViewModel(repository: viewModel.repository[indexPath.row])
        repositoryViewCell.repositoryCellViewModel = cellModel
        
        return repositoryViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        self.repositoryViewModel?.loadMoreRepository(index: indexPath.row, completion: { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success:
                self.repositoryCollectionView.reloadData()
            case let .failure(error):
                self.openErrorAlert?(error)
            }
        })
    }
}

extension RepositoryView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let cell = collectionView.cellForItem(at: indexPath) as? RepositoryCell else {
            return
        }
        guard let repository = cell.repositoryCellViewModel?.repository else {
            return
        }
        guard let owner = self.repositoryViewModel?.owner else {
            return
        }
        
        self.didSelectCell?(repository.name, owner)
    }
}

extension RepositoryView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        CGSize(width: self.repositoryCollectionView.bounds.width, height: 120.0)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let widthPerItem: CGFloat = self.repositoryCollectionView.bounds.width * 0.5 - 10.0
        
        return CGSize(width: widthPerItem, height: 120.0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5.0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10.0
    }
}
