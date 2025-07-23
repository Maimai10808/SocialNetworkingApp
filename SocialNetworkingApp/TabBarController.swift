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
        
        delegate = self
        
        let mainStoryboard        = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController    = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        homeNavigationController.tabBarItem.image    = UIImage(systemName: "house")
        homeNavigationController.tabBarItem.title    = "Home"
        
        
        let postStoryboard        = UIStoryboard(name: "Post", bundle: nil)
        let postViewController    = postStoryboard.instantiateViewController(withIdentifier: "PostViewController")
        postViewController.tabBarItem.image    = UIImage(systemName: "paperplane")
        postViewController.tabBarItem.title    = "Post"
        
        let accountStoryboard     = UIStoryboard(name: "Account", bundle: nil)
        let accountViewController = accountStoryboard.instantiateViewController(withIdentifier: "AccountViewController")
        let accountNavigationController = UINavigationController(rootViewController: accountViewController)
        accountNavigationController.tabBarItem.image = UIImage(systemName: "person")
        accountNavigationController.tabBarItem.title = "Account"
        
        viewControllers = [homeNavigationController, postViewController, accountNavigationController]
         
    }
    
    
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let selectedViewController = tabBarController.selectedViewController
        guard selectedViewController != nil else { return false }
        guard selectedViewController != viewController else { return false }
        guard let controllerIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else { return false }
        
        if controllerIndex == 1 {
            let postStoryboard        = UIStoryboard(name: "Post", bundle: nil)
            let postViewController    = postStoryboard.instantiateViewController(withIdentifier: "PostViewController")
            
            selectedViewController?.present(postViewController, animated: true)
            
            return false
        }
        
        return true
    }
    
}





