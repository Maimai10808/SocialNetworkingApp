//
//  PostViewController.swift
//  SocialNetworkingApp
//
//  Created by mac on 7/23/25.
//

import UIKit
import Photos
import PhotosUI


class PostViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var cameraImageView: UIImageView!
    
    var selectedImage: UIImage? {
        didSet {
            if selectedImage != nil {
                previewImageView.image    = selectedImage
                cameraImageView .isHidden = true
            } else {
                previewImageView.image    = nil
                cameraImageView .isHidden = false
            }
            
        }
    }
    
    
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
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                imagePicker.delegate = self
                self.present(imagePicker, animated: true)
            }
            
        }
        
        let libraryAction = UIAlertAction(title: "Library", style: .default) { _ in
            var phPickerCongiguration = PHPickerConfiguration(photoLibrary: .shared())
            phPickerCongiguration.filter = PHPickerFilter.any(of: [.images])
            let phPickerViewcontroller = PHPickerViewController(configuration: phPickerCongiguration)
            phPickerViewcontroller.delegate = self
            
            self.present(phPickerViewcontroller, animated: true)
            
        }
        
        let cancelAction  = UIAlertAction(title: "cancel",  style: .cancel ) { _ in
            
        }
        
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    


}


extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            selectedImage = image
        }
        
        picker.dismiss(animated: true)
        
    }
    
}

extension PostViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        if let result = results.first {
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                
                if let error = error {
                    print(error.localizedDescription)
                    
                    DispatchQueue.main.async {
                        self.presentError(title: "Image Error", message: "Could not load image")
                    }
                    return
                }
                
                
                guard let image = reading as? UIImage else {
                    DispatchQueue.main.async {
                        self.presentError(title: "Image Error", message: "Could not load image")
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.selectedImage = image
                }

                
             }
            
            
         }
        
     }
    
}
