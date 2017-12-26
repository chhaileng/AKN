//
//  ArticleService.swift
//  AKN
//
//  Created by Chhaileng Peng on 12/24/17.
//  Copyright © 2017 Chhaileng Peng. All rights reserved.
//

import Foundation
import Alamofire

class ArticleService {
    var articles = [Article]()
    
    let headers = [ "Authorization": "Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ=",
                    "Content-Type": "application/json",
                    "Accept": "application/json" ]
    
    let ARTICLE_GET_URL = "http://api-ams.me/v1/api/articles"
    let ARTICLE_POST_URL = "http://api-ams.me/v1/api/articles"
    let ARTICLE_UPLOAD_URL = "http://api-ams.me/v1/api/uploadfile/single"
    let ARTICLE_PUT_URL = "http://api-ams.me/v1/api/articles"
    let ARTICLE_DELETE_URL = "http://api-ams.me/v1/api/articles"
    
    var delegate: ArticleServiceProtocol?
    
    func getArticles(page: Int, limit: Int) {
        let request_url = "\(ARTICLE_GET_URL)?page=\(page)&limit=\(limit)"
        
        Alamofire.request(request_url, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let data = response.data {
                var articles = [Article]()
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
                    
                    if let jsonArticle = jsonResult["DATA"] as? [AnyObject] {
                        for article in jsonArticle {
                            articles.append(Article(JSON: article as! [String: Any])!)
                        }
                        self.delegate?.didResponseArticles(articles)
                        print("Success")
                    }
                } catch {
                    print("Failed to get data")
                }
            }
        }
    }
    
    func insertUpdateArticle(article: Article, image: Data) {
        Alamofire.upload(multipartFormData: { (multipart) in
            multipart.append(image, withName: "FILE", fileName: ".jpg", mimeType: "image/jpeg")
        }, to: ARTICLE_UPLOAD_URL, method:.post, headers:headers) { (encodingResult) in
            switch encodingResult {
            case .success(request: let upload, streamingFromDisk: _ , streamFileURL: _):
                upload.responseJSON(completionHandler: { (response) in
                    if let data = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String:Any] {
                        let image_url = data["DATA"] as! String
                        article.image = image_url
                        if article.id == 0 {
                            self.insertNewArticle(article: article)
                        } else {
                            self.updateArticle(article: article)
                        }
                    }
                })
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func insertNewArticle(article: Article) {
        let newArticle:[String:Any] = [
            "TITLE": article.title!,
            "DESCRIPTION": article.description!,
            "AUTHOR": 1,
            "CATEGORY_ID": 1,
            "STATUS": "1",
            "IMAGE": article.image!
        ]
        Alamofire.request(ARTICLE_POST_URL, method: .post, parameters: newArticle, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.isSuccess {
                self.delegate?.didResponseMessage("Insert Successfully")
            }
        }
    }
    
    func updateArticle(article: Article) {
        let newData:[String:Any] = [
            "TITLE": article.title!,
            "DESCRIPTION": article.description!,
            "AUTHOR": 1,
            "CATEGORY_ID": 1,
            "STATUS": "1",
            "IMAGE": article.image!
        ]
        
        Alamofire.request("\(ARTICLE_PUT_URL)/\(article.id!)", method: .put, parameters: newData, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.isSuccess {
                self.delegate?.didResponseMessage("Update Successfully")
            }
        }
    }
    
    func deleteArticle(id: Int) {
        Alamofire.request("\(ARTICLE_DELETE_URL)/\(id)", method: .delete, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.isSuccess {
                self.delegate?.didResponseMessage("Delete Successfully")
            }
        }
    }
}
