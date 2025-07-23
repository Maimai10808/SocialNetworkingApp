//
//  Extension+UIViewController.swift
//  SocialNetworkingApp
//
//  Created by mac on 7/23/25.
//

import Foundation
import UIKit

extension UIViewController {
     
    func presentError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
}
