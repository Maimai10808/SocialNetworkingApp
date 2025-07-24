//
//  UploadImageAndPostViewController.swift
//  SocialNetworkingApp
//
//  Created by mac on 7/24/25.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

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
                let downloadURL = url?.absoluteString
            }
            
            
        }
        
        
        
        
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
    }
    

}
