//
//  ArticleDetailViewController.swift
//  AKN
//
//  Created by Chhaileng Peng on 12/25/17.
//  Copyright © 2017 Chhaileng Peng. All rights reserved.
//

import UIKit
import Kingfisher
import Photos

class ArticleDetailViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var articleTitle: String?
    var articleCreatedDate: String?
    var articleDescription: String?
    var articleImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        titleLabel.text = articleTitle!
        dateLabel.text = articleCreatedDate!.formatDate(getTime: true)
        descriptionLabel.text = articleDescription!
        
        if articleImage != nil {
            let url = URL(string: articleImage!)
            articleImageView.kf.setImage(with: url)
        } else {
            articleImageView.image = UIImage(named: "no-image")
        }
        
        longPressOnImage()
        
    }
    
    @IBAction func saveImage(_ sender: UIBarButtonItem) {
        checkLibraryPermission()
    }
    
    func saveImage() {
        DispatchQueue.main.async {
            let imageData = UIImagePNGRepresentation(self.articleImageView.image!)
            let compresedImage = UIImage(data: imageData!)
            UIImageWriteToSavedPhotosAlbum(compresedImage!, nil, nil, nil)
            
            let saved = UIAlertController(title: "Saved to Library", message: nil, preferredStyle: .alert)
            saved.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(saved, animated: true)
        }
    }
    
    func checkLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            self.saveImage()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization( { (newStatus) in
                if newStatus ==  PHAuthorizationStatus.authorized {
                    self.saveImage()
                }
            })
        case .restricted, .denied:
            let denied = UIAlertController(title: "Permission denied", message: "Goto Settings > Privacy > Photos and allow permission.", preferredStyle: .alert)
            denied.addAction(UIAlertAction(title: "Not now", style: .cancel, handler: nil))
            denied.addAction(UIAlertAction(title: "Setting", style: .default, handler: { action in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: nil)
                }
            }))
            present(denied, animated: true)
        }
    }
    
}

extension ArticleDetailViewController: UIGestureRecognizerDelegate {
    func longPressOnImage() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(alertToSaveImage))
        longPress.minimumPressDuration = 0.5
        longPress.allowableMovement = 15
        longPress.delaysTouchesBegan = false
        longPress.delegate = self as UIGestureRecognizerDelegate
        self.articleImageView.isUserInteractionEnabled = true
        self.articleImageView.addGestureRecognizer(longPress)
    }
    
    @objc func alertToSaveImage() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save image", style: .default, handler: { action in
            self.checkLibraryPermission()
        }))
        present(alert, animated: true)
    }
}

