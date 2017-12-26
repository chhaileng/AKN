//
//  ArticlePresenter.swift
//  AKN
//
//  Created by Chhaileng Peng on 12/24/17.
//  Copyright © 2017 Chhaileng Peng. All rights reserved.
//

import Foundation

class ArticlePresenter: ArticleServiceProtocol {
    
    var delegate: ArticlePresenterProtocol?
    var articleService: ArticleService?
    
    init() {
        self.articleService = ArticleService()
        self.articleService?.delegate = self
    }
    
    func didResponseArticles(_ articles: [Article]) {
        self.delegate?.didResponseArticles(articles)
    }
    
    func didResponseMessage(_ msg: String) {
        self.delegate?.didResponseMessage(msg)
    }
    
    func getArticles(page: Int, limit: Int) {
        self.articleService?.getArticles(page: page, limit: limit)
    }
    
    func insertUpdateArticle(article: Article, image: Data) {
        self.articleService?.insertUpdateArticle(article: article, image: image)
    }
    
    func deleteArticle(id: Int) {
        self.articleService?.deleteArticle(id: id)
    }
    
}
