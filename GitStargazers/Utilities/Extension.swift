//
//  Extension.swift
//  GitStargazers
//
//  Created by c331657 on 19/02/2021.
//  Copyright © 2021 c331657. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(withTitle title: String,
                   andMessage message: String) {
        let blurVisualEffectView = self.blurEffect()
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let closeAction = UIAlertAction(title: "Close", style: .cancel) { _ in
            self.navigationController?.popViewController(animated: true)
            blurVisualEffectView.removeFromSuperview()
        }
        
        alertController.addAction(closeAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showStargazerAlert(ownerName: String = "",
                            completion: @escaping ((String, String) -> Void)) {
        let blurVisualEffectView = self.blurEffect()
        
        let alertController = UIAlertController(title: "Search Stargazers", message: "", preferredStyle: .alert)
        alertController.addTextField { textField -> Void in
            if ownerName.isEmpty {
                textField.placeholder = "Owner name"
            } else {
                textField.text = ownerName
            }
        }
        alertController.addTextField { textField -> Void in
            textField.placeholder = "Repository name"
        }
        
        let saveAction = UIAlertAction(title: "Search", style: .default, handler: { _-> Void in
            blurVisualEffectView.removeFromSuperview()
            
            guard let fields = alertController.textFields else { return }
            guard let ownerName = fields.first?.text else { return }
            guard let repositoryName = fields.last?.text else { return }
            
            completion(ownerName, repositoryName)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { _-> Void in
            blurVisualEffectView.removeFromSuperview()
        })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.navigationController?.present(alertController, animated: true, completion: nil)
    }
}

fileprivate extension UIViewController {
    func blurEffect() -> UIVisualEffectView {
        guard let navigationController = self.navigationController else {
            return UIVisualEffectView()
        }
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        
        navigationController.view.addSubview(blurVisualEffectView)
        
        blurVisualEffectView.translatesAutoresizingMaskIntoConstraints = false
        let blurVisualEffectViewConstraints = [
            blurVisualEffectView.leadingAnchor.constraint(equalTo: navigationController.view.leadingAnchor),
            blurVisualEffectView.topAnchor.constraint(equalTo: navigationController.view.topAnchor),
            blurVisualEffectView.trailingAnchor.constraint(equalTo: navigationController.view.trailingAnchor),
            blurVisualEffectView.bottomAnchor.constraint(equalTo: navigationController.view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(blurVisualEffectViewConstraints)
        
        return blurVisualEffectView
    }
}
