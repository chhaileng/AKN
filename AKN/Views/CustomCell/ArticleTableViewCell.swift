//
//  ArticleTableViewCell.swift
//  AKN
//
//  Created by Chhaileng Peng on 12/25/17.
//  Copyright © 2017 Chhaileng Peng. All rights reserved.
//

import UIKit
import Kingfisher

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(article: Article) {
        self.titleLabel.text = article.title
        
        self.dateLabel.text = article.date!.formatDate(getTime: true)
        
        if article.image == nil {
            articleImageView.image = UIImage(named: "no-image")
        } else {
            let url = URL(string: article.image!)
            articleImageView.kf.setImage(with: url)
        }
    }
    
}
