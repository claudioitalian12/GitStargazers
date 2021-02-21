//
//  UserViewCell.swift
//  GitStargazers
//
//  Created by c331657 on 19/02/2021.
//  Copyright © 2021 c331657. All rights reserved.
//

import UIKit
import Kingfisher

struct UserViewCellModel {
    
    // MARK: - internal property
    
    var user: User
    var accessoryType: UITableViewCell.AccessoryType = .none
    var isInteractionEnable: Bool = true
    var userLogin: String {
        return user.userName
    }
    var userType: String {
        return user.type
    }
    var avatarUrl: String {
        return user.avatarURL
    }
}

class UserViewCell: UITableViewCell, ReusableCell {
    
    private var nameLabel = UILabel()
    private var typeLabel = UILabel()
    private var avatar = UIImageView()
    private var stackUser = UIStackView()
    
    var cellModel: UserViewCellModel? {
        didSet {
            self.update()
        }
    }
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? .lightGray : .clear
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setup()
        self.style()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.avatar.image = nil
    }
}

fileprivate extension UserViewCell {
    
    // MARK: - Setup
    
    func setup() {
        self.stackUser.addArrangedSubview(self.nameLabel)
        self.stackUser.addArrangedSubview(self.typeLabel)
        self.addSubview(self.stackUser)
        self.addSubview(self.avatar)
    }
    
    // MARK: - Style
    
    func style() {
        self.nameLabel.font = UIFont.boldSystemFont(ofSize: 19.0)
        self.nameLabel.textAlignment = .left
        self.nameLabel.textColor = .black
        
        self.typeLabel.textAlignment = .left
        self.typeLabel.textColor = .black
        
        self.stackUser.axis = .vertical
        self.stackUser.alignment = .leading
        self.stackUser.distribution = .fillProportionally
    }
    
    // MARK: - Layout
    
    func layout() {
        self.avatar.translatesAutoresizingMaskIntoConstraints = false
        let avatarConstraints = [
            self.avatar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            self.avatar.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
            self.avatar.widthAnchor.constraint(equalToConstant: 100.0),
            self.avatar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0)
        ]
        NSLayoutConstraint.activate(avatarConstraints)
        
        self.stackUser.translatesAutoresizingMaskIntoConstraints = false
        let stackUserConstraints = [
            self.stackUser.leadingAnchor.constraint(equalTo: self.avatar.trailingAnchor, constant: 10.0),
            self.stackUser.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
            self.stackUser.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10.0),
            self.stackUser.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0)
        ]
        NSLayoutConstraint.activate(stackUserConstraints)
    }
    
    // MARK: - Update
    
    func update() {
        guard let viewModel = self.cellModel else { return }
        let url = URL(string: viewModel.avatarUrl)
        self.avatar.kf.setImage(with: url)
        
        self.nameLabel.text = viewModel.userLogin
        self.typeLabel.text = "Account Type: \(viewModel.userType)"
        
        self.accessoryType = viewModel.accessoryType
        self.isUserInteractionEnabled = viewModel.isInteractionEnable
    }
}
