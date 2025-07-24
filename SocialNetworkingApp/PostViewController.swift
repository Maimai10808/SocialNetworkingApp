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

    @IBOutlet weak var containerView      : UIView!
    @IBOutlet weak var previewImageView   : UIImageView!
    @IBOutlet weak var cameraImageView    : UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var postButton         : UIButton!
    
    let placeholderText = "What's on your mind?"
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UploadImageAndPostSegue" {
            let destinationVC = segue.destination as! UploadImageAndPostViewController
            // 假设 sender 是传递的数据源，或者你需要从当前视图控制器获取数据
            // 构造一个 PostToUpload 实例
            let postToUpload = PostToUpload(
                title: "示例标题", // 替换为实际标题
                content: "示例内容", // 替换为实际内容
                image: UIImage(named: "exampleImage") // 替换为实际图片
            )
            destinationVC.postToUpload = postToUpload
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewImageView.contentMode = .scaleAspectFill
        containerView.backgroundColor = UIColor.lightGray
        containerView.clipsToBounds = true
        
        let containerTap = UITapGestureRecognizer(target: self, action: #selector(showCameraOptions))
        containerView.addGestureRecognizer(containerTap)
        containerView.isUserInteractionEnabled = true
        
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.text = placeholderText
        descriptionTextView.delegate = self
        
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(endTextViewEditing))
        view.addGestureRecognizer(viewTap)
        view.isUserInteractionEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.layer.cornerRadius = 8
        descriptionTextView.layer.cornerRadius = 6
        postButton.layer.cornerRadius = 6
    }
    
    @objc func endTextViewEditing() {
        view.endEditing(true)
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
    
    
    
    @IBAction func postButtonTapped(_ sender: Any) {
        guard let selectedImage = selectedImage else {
            presentError(title: "Image Required", message: "Please attach an image with your post.")
            return
        }
        guard let postText = descriptionTextView.text, postText.count > 5 && postText.count < 60 else {
            presentError(title: "Post Text Error", message: "Please ensure the number of characters in your post text is greater than 5 and less than 60.")
            return
        }
        performSegue(withIdentifier: "UploadImageAndPostSegue", sender: nil)
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


extension PostViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == UIColor.lightGray {
            descriptionTextView.textColor = UIColor.black
            descriptionTextView.text = ""
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text == "" {
            descriptionTextView.text = placeholderText
            descriptionTextView.textColor = UIColor.lightGray
        }
    }
    
    
}
