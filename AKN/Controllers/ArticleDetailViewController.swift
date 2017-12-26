//
//  ArticleDetailViewController.swift
//  AKN
//
//  Created by Chhaileng Peng on 12/25/17.
//  Copyright © 2017 Chhaileng Peng. All rights reserved.
//

import UIKit
import Kingfisher

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
        
    }
    
    @IBAction func saveImage(_ sender: UIBarButtonItem) {
        UIImageWriteToSavedPhotosAlbum(articleImageView.image!, nil, nil, nil)
//        let saved = UIAlertController(title: "Photo successfully save to library", message: nil, preferredStyle: .alert)
//        saved.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(saved, animated: true)
    }
    
}

