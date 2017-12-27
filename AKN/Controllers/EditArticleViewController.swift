//
//  EditArticleViewController.swift
//  AKN
//
//  Created by Chhaileng Peng on 12/26/17.
//  Copyright © 2017 Chhaileng Peng. All rights reserved.
//

import UIKit
import Kingfisher
import KVLoading
import Photos

class EditArticleViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var articlePresenter: ArticlePresenter?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var articleId: Int?
    var articleImage: String?
    var articleTitle: String?
    var articleDescription: String?
    
    var isUpdate = false
    
    var article = Article()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.articlePresenter = ArticlePresenter()
        self.articlePresenter?.delegate = self
        dateLabel.text = getCurrentDate()
        
        if isUpdate {
            self.title = "Update Article"
            titleTextField.text = articleTitle
            descriptionTextView.text = articleDescription
            
            if articleImage == nil {
                imageView.image = #imageLiteral(resourceName: "no-image")
            } else {
                let url = URL(string: articleImage!)
                imageView.kf.setImage(with: url!)
            }
        }
        
        let browseImage : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(browseImage(gesture:)))
        imageView.addGestureRecognizer(browseImage)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        DispatchQueue.main.async {
            self.imageView.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func browseImage(gesture : UITapGestureRecognizer!) {
        checkLibraryPermission()
    }
    
    func showBrowseImage() {
        let imageController = UIImagePickerController()
        imageController.delegate = self
        imageController.sourceType = .photoLibrary
        self.present(imageController, animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        KVLoading.show()
        if isUpdate {
            article.id = articleId!
        } else {
            article.id = 0
        }
        let image = UIImageJPEGRepresentation(imageView.image!, 0.5)
        article.title = titleTextField.text
        article.description = descriptionTextView.text
        self.articlePresenter?.insertUpdateArticle(article: article, image: image!)
    }
    
    func checkLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            self.showBrowseImage()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization( { (newStatus) in
                if newStatus ==  PHAuthorizationStatus.authorized {
                    self.showBrowseImage()
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
    
    func getCurrentDate() -> String {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        var h = "\(hour)"
        var m = "\(minute)"
        if hour < 10 {
            h = "0\(hour)"
        }
        if minute < 10 {
            m = "0\(minute)"
        }
        return "\(day)-\(month)-\(year) / \(h):\(m)"
    }

}

extension EditArticleViewController: ArticlePresenterProtocol {
    
    func didResponseArticles(_ articles: [Article]) { }
    
    func didResponseMessage(_ msg: String) {
        KVLoading.hide()
        let saved = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
        saved.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        present(saved, animated: true)
    }
    
}
