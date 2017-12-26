//
//  ViewController.swift
//  AKN
//
//  Created by Chhaileng Peng on 12/24/17.
//  Copyright © 2017 Chhaileng Peng. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var articlePresenter: ArticlePresenter?
    var articles: [Article]?
    
    let refreshControl = UIRefreshControl()
    let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    var currentPage: Int?
    var n = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.articles = [Article]()
        self.articlePresenter = ArticlePresenter()
        currentPage = 1
        self.articlePresenter?.getArticles(page: currentPage!, limit: 15)
        self.articlePresenter?.delegate = self
        
        // customize view
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        self.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshArticles), for: .valueChanged)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ArticleTableViewCell", owner: self, options: nil)?.first as! ArticleTableViewCell
        cell.configureCell(article: articles![indexPath.row])
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleDetail = self.storyboard?.instantiateViewController(withIdentifier: "articleDetailStoryboard") as! ArticleDetailViewController
        
        articleDetail.articleTitle = articles![indexPath.row].title
        articleDetail.articleDescription = articles![indexPath.row].description
        articleDetail.articleCreatedDate = articles![indexPath.row].date
        articleDetail.articleImage = articles![indexPath.row].image
        
        self.navigationController?.pushViewController(articleDetail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let confirmDelete = UIAlertController(title: "Are you sure to delete this article?", message: nil, preferredStyle: .alert)
            confirmDelete.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.articlePresenter?.deleteArticle(id: self.articles![indexPath.row].id!)
                self.articles?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }))
            confirmDelete.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(confirmDelete, animated: true)
        }

        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            let editArticle = self.storyboard?.instantiateViewController(withIdentifier: "editArticleStoryboard") as! EditArticleViewController
            
            editArticle.articleId = self.articles![indexPath.row].id
            editArticle.articleTitle = self.articles![indexPath.row].title
            editArticle.articleDescription = self.articles![indexPath.row].description
            editArticle.articleImage = self.articles![indexPath.row].image
            
            editArticle.isUpdate = true
            
            self.navigationController?.pushViewController(editArticle, animated: true)
        }

        return [delete, edit]
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        n = 0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        n += 1
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate && n >= 1 && scrollView.contentOffset.y >= 0 {
            tableView.layoutIfNeeded()
            self.currentPage = self.currentPage! + 1
            self.tableView.tableFooterView = indicatorView
            self.tableView.tableFooterView?.isHidden = false
            self.tableView.tableFooterView?.center = indicatorView.center
            self.indicatorView.startAnimating()
            self.articlePresenter?.getArticles(page: currentPage!, limit: 15)
            n = 0
        } else if !decelerate {
            n = 0
        }
    }
    
    @objc private func refreshArticles() {
        self.articles = []
        currentPage = 1
        self.articlePresenter?.getArticles(page: currentPage!, limit: 15)
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    @IBAction func actionButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Article Management System", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Developer website", style: .default, handler: { action in
            if let url = URL(string: "https://www.chhaileng.com") {
                UIApplication.shared.open(url, options: [:])
            }
        }))
        alert.addAction(UIAlertAction(title: "Version", style: .default, handler: { action in
            let about = UIAlertController(title: "Article Management System", message: "Developed by Chhaileng Peng\nVersion 1.0.0", preferredStyle: .alert)
            about.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(about, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @IBAction func addNewArticle(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showEdit", sender: nil)
    }

}

extension ViewController: ArticlePresenterProtocol {
    
    func didResponseArticles(_ articles: [Article]) {
        self.articles = self.articles! + articles
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.indicatorView.stopAnimating()
        }
    }
    
    func didResponseMessage(_ msg: String) { }
    
}

