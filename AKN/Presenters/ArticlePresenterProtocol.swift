//
//  ArticlePresenterProtocol.swift
//  AKN
//
//  Created by Chhaileng Peng on 12/24/17.
//  Copyright © 2017 Chhaileng Peng. All rights reserved.
//

import Foundation

protocol ArticlePresenterProtocol {
    func didResponseArticles(_ articles: [Article])
    func didResponseMessage(_ msg: String)
}
