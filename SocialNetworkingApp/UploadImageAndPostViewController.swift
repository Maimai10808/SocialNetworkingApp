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
            // 处理图片为空或转换失败的情况
            print("Error")
            return
        }
        
        guard let userId = Auth.auth().currentUser?.uid else {
            
            return
        }
        
        progrssView.progress = 0
        
        let imageID = UUID().uuidString.lowercased().lowercased().replacingOccurrences(of: "-", with: "_")
        
        let imageName = imageID + ".jpeg"
        
        let imagePath = "images/\(userId)/\(imageName)"
        
        let storegeReference = Storage.storage().reference(withPath: imagePath)
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        uploadTask = storegeReference.putData(imageData, metadata: metaData) { _, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            
            storegeReference.downloadURL { url, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let downloadURL = url?.absoluteString {
                    let postData: [String: Any] = [
                        "imageURL"   : downloadURL,
                        "description": self.postToUpload.posttext,
                        "userId"     : userId,
                        "createdAt"  : Date().timeIntervalSince1970
                    ]
                    
                    Firestore.firestore().collection("posts").document().setData(postData) { error in
                        if let error {
                            print(error.localizedDescription)
                            return
                        }
                        self.dismiss(animated: true)
                    }
                }
            }
        }
        
        uploadTask!.observe(.progress, handler: { snapshot in
            let percentComplete = Float(snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount)
            
            DispatchQueue.main.async {
                self.progrssView.setProgress(percentComplete, animated: true)
            }
           
        })
        
        
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        uploadTask?.cancel()
    }
    

}
