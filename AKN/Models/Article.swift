//
//  Article.swift
//  AKN
//
//  Created by Chhaileng Peng on 12/24/17.
//  Copyright © 2017 Chhaileng Peng. All rights reserved.
//

import Foundation
import ObjectMapper

class Article: Mappable {
    var id: Int?
    var title: String?
    var description: String?
    var category: Category?
    var date: String?
    var image: String?
    
    init() {
        self.category = Category()
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id      <- map["ID"]
        title   <- map["TITLE"]
        description <- map["DESCRIPTION"]
        category    <- map["CATEGORY"]
        date    <- map["CREATED_DATE"]
        image   <- map["IMAGE"]
    }
}

class Category: Mappable {
    var id: Int?
    var name: String?
    
    init() { }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id      <- map["ID"]
        name    <- map["NAME"]
    }
}
