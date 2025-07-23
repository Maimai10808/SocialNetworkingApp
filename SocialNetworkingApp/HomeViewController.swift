//
//  HomeViewController.swift
//  SocialNetworkingApp
//
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn


class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let spacing: CGFloat = 10
    let numberOfItemPerRow: CGFloat = 3
    lazy var cellWidth: CGFloat = {
        let availableWidth = collectionView.frame.width - (CGFloat(numberOfItemPerRow - 1) * spacing)
        let cellWidth  = availableWidth / numberOfItemPerRow
        return cellWidth
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate   = self
    }
    
    
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
            
            cell.postImageView.image = UIImage(systemName: "person")
            return cell
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
            
            
            cell.postImageView.image = UIImage(systemName: "house")
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
            
            
            cell.postImageView.image = UIImage(systemName: "person.fill")
            return cell
        }
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: cellWidth, height: cellWidth)
    }

    
}

