//
//  PostViewController.swift
//  SocialNetworkingApp
//
//  Created by mac on 7/23/25.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var cameraImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewImageView.contentMode = .scaleAspectFill
        containerView.backgroundColor = UIColor.lightGray
        
        let containerTap = UITapGestureRecognizer(target: self, action: #selector(showCameraOptions))
        containerView.addGestureRecognizer(containerTap)
        containerView.isUserInteractionEnabled = true
        

    }
    
    @objc func showCameraOptions() {
        
        let alert = UIAlertController(title: "Choose Image Source",message: "Attach an image to your post" ,preferredStyle: .actionSheet)
        
        let cameraAction  = UIAlertAction(title: "Camera",  style: .default) { _ in
            
        }
        
        let libraryAction = UIAlertAction(title: "Library", style: .default) { _ in
            
        }
        
        let cancelAction  = UIAlertAction(title: "cancel",  style: .cancel ) { _ in
            
        }
        
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    


}
