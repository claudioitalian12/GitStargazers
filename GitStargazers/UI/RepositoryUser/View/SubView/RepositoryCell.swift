//
//  RepositoryCell.swift
//  GitStargazers
//
//  Created by c331657 on 20/02/2021.
//  Copyright © 2021 c331657. All rights reserved.
//

import UIKit

struct RepositoryCellViewModel {
    
    // MARK: - internal property
    
    var repository: RepositoryElement
    var name: String {
        return repository.name
    }
    var stargazersCount: Int {
        return repository.stargazersCount
    }
}

class RepositoryCell: UICollectionViewCell, ReusableCell {
    
    // MARK: - private property
    
    private let nameTextView = UITextView()
    private let starImage = UIImageView()
    private let stargazersCountLabel = UILabel()
    
    var repositoryCellViewModel: RepositoryCellViewModel? {
        didSet {
            self.update()
        }
    }
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? .lightGray : .clear
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
        self.style()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func setSelected(_ selected: Bool, animated: Bool) {
        self.backgroundColor = selected ? .gray : .white
    }
}

fileprivate extension RepositoryCell {
    
    // MARK: - Setup
    
    func setup() {
        self.contentView.addSubview(self.starImage)
        self.contentView.addSubview(self.nameTextView)
        self.contentView.addSubview(self.stargazersCountLabel)
    }
    
    // MARK: - Style
    
    func style() {
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.borderColor = UIColor.gray.cgColor
        
        self.starImage.image = UIImage(named: "gitstar")
        self.starImage.contentMode = .scaleAspectFill
        
        self.stargazersCountLabel.textAlignment = .center
        self.stargazersCountLabel.textColor = .black
        
        self.nameTextView.font = UIFont.boldSystemFont(ofSize: 19)
        self.nameTextView.isUserInteractionEnabled = false
        self.nameTextView.backgroundColor = .none
        self.nameTextView.textAlignment = .left
        self.nameTextView.textColor = .black
    }
    
    // MARK: - Update
    
    func update() {
        guard let viewModel = self.repositoryCellViewModel else {
            return
        }
        
        self.stargazersCountLabel.text = "Stars count: \(viewModel.stargazersCount)"
        self.nameTextView.text = viewModel.name
    }
    
    // MARK: - Layout
    
    func layout() {
        self.starImage.translatesAutoresizingMaskIntoConstraints = false
        let starImageConstraints = [
            self.starImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5.0),
            self.starImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0),
            self.starImage.widthAnchor.constraint(equalToConstant: 25.0),
            self.starImage.heightAnchor.constraint(equalToConstant: 25.0),
        ]
        NSLayoutConstraint.activate(starImageConstraints)
        
        self.stargazersCountLabel.translatesAutoresizingMaskIntoConstraints = false
        let stargazersCountLabelConstraints = [
            self.stargazersCountLabel.leadingAnchor.constraint(equalTo: self.starImage.leadingAnchor, constant: 5.0),
            self.stargazersCountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5.0),
            self.stargazersCountLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0),
            self.stargazersCountLabel.heightAnchor.constraint(equalToConstant: 25.0),
        ]
        NSLayoutConstraint.activate(stargazersCountLabelConstraints)
        
        self.nameTextView.translatesAutoresizingMaskIntoConstraints = false
        let nameTextViewConstraints = [
            self.nameTextView.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.nameTextView.topAnchor.constraint(equalTo: self.starImage.bottomAnchor, constant: 10.0),
            self.nameTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10.0)
        ]
        NSLayoutConstraint.activate(nameTextViewConstraints)
    }
}
