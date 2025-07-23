//
//  LoginViewController.swift
//  SocialNetworkingApp
//
//  Created by mac on 7/22/25.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import Foundation

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginWithGoogleButtonTapped(_ sender: Any) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        
        
        
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self]user, error in
                guard let strongself = self else { return }
                
                
                if let error = error {
                    print(error.localizedDescription)
                    strongself.presentError(title: "Login Error", message: "Something went wrong. Please try again later.")
                    
                    return
                }
                
                guard let user = user else {
                    strongself.presentError(title: "Login Error", message: "Something went wrong. Please try again later.")
                    
                    return
                }
                strongself.authenticate(user: user)
                
            }
        }
        
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self]result, error in
            guard let strongself = self else { return }
            
            
            if let error = error {
                print(error.localizedDescription)
                strongself.presentError(title: "Login Error", message: "Something went wrong. Please try again later.")
                
                return
            }

            guard let user = result?.user else {
                strongself.presentError(title: "Login Error", message: "Something went wrong. Please try again later.")
                
                return
            }
            
            strongself.authenticate(user: user)
          
    }
        
    }
    
    func authenticate(user: GIDGoogleUser) {
        guard let idToken = user.idToken?.tokenString else {
            presentError(title: "Login Error", message: "Something went wrong. Please try again later.")
            
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: user.accessToken.tokenString)

          Auth.auth().signIn(with: credential) { [weak self]result, error in
              guard let strongself = self else { return }
              if let error = error {
                  print(error.localizedDescription)
                  strongself.presentError(title: "Login Error", message: "Something went wrong. Please try again later.")
                  
                  return
              }

              let tabBarController      = TabBarController()
              
              let window = UIApplication.keyWindow
              window?.rootViewController = tabBarController
          }
        
    }
    
    

}
