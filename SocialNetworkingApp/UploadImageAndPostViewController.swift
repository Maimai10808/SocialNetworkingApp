//
//  UploadImageAndPostViewController.swift
//  SocialNetworkingApp
//
//  Created by mac on 7/24/25.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class UploadImageAndPostViewController: UIViewController {
    
    
    @IBOutlet weak var progrssView: UIProgressView!
    
    var postToUpload: PostToUpload!
    var uploadTask: StorageUploadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uploadImage()
    }
    
    func uploadImage() {
        
        guard let image = postToUpload.image,
              let imageData = image.jpegData(compressionQuality: 0.7) else {
            presentError(title: "Image Error", message: "Image could not be used.") {
                self.dismiss(animated: true)
            }
            return
        }
        
        guard let userId = Auth.auth().currentUser?.uid else {
            presentError(title: "Sign In Error", message: "You need to be signed in to upload an image.") {
                self.dismiss(animated: true)
            }
            return
        }
        
        progrssView.progress = 0
        
        let imageID = UUID().uuidString.lowercased().lowercased().replacingOccurrences(of: "-", with: "_")
        
        let imageName = imageID + ".jpeg"
        
        let imagePath = "images/\(userId)/\(imageName)"
        
        let storegeReference = Storage.storage().reference(withPath: imagePath)
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        uploadTask = storegeReference.putData(imageData, metadata: metaData) { [weak self] _, error in
            guard let strongself = self else { return }
            
            
            if let error = error {
                strongself.presentError(title: "Upload Error", message: "Please check your internet connection.")
                print(error.localizedDescription)
                return
            }
            
            
            storegeReference.downloadURL { url, error in
                
                if let error = error {
                    strongself.presentError(title: "Upload Error", message: "Please check your internet connection.")
                    print(error.localizedDescription)
                    return
                }
                
                guard let downloadURL = url?.absoluteString else {
                    strongself.presentError(title: "Upload Error", message: "Please check your internet connection.")
                    return
                }
                
                let postData: [String: Any] = [
                    "imageURL"   : downloadURL,
                    "description": strongself.postToUpload.posttext,
                    "userId"     : userId,
                    "createdAt"  : Date().timeIntervalSince1970
                ]
                
                Firestore.firestore().collection("posts").document().setData(postData) { error in
                    if let error {
                        strongself.presentError(title: "Post Error", message: "Please try again post later.")
                        print(error.localizedDescription)
                        return
                    }
                    strongself.dismiss(animated: true)
                }
                
            }
        }
        
        uploadTask!.observe(.progress, handler: { [weak self] snapshot in
            guard let strongself = self else { return }
            
            let percentComplete = Float(snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount)
            
            DispatchQueue.main.async {
                strongself.progrssView.setProgress(percentComplete, animated: true)
            }
           
        })
        
        
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        uploadTask?.cancel()
    }
    

}
