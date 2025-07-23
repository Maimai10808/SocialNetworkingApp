//
//  TabBarController.swift
//  SocialNetworkingApp
//
//  Created by mac on 7/23/25.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainStoryboard        = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController    = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        homeViewController.tabBarItem.image    = UIImage(systemName: "house")
        homeViewController.tabBarItem.title    = "Home"
        
        let postStoryboard        = UIStoryboard(name: "Post", bundle: nil)
        let postViewController    = postStoryboard.instantiateViewController(withIdentifier: "PostViewController")
        postViewController.tabBarItem.image    = UIImage(systemName: "paperplane")
        postViewController.tabBarItem.title    = "Post"
        
        let accountStoryboard     = UIStoryboard(name: "Account", bundle: nil)
        let accountViewController = accountStoryboard.instantiateViewController(withIdentifier: "AccountViewController")
        accountViewController.tabBarItem.image = UIImage(systemName: "person")
        accountViewController.tabBarItem.title = "Account"
        
        viewControllers = [homeViewController, postViewController, accountViewController]
         
    }
    
    
}





