//
//  Categories.swift
//  MindValley
//
//  Created by Yura on 6/30/22.
//

import Foundation

struct CategoriesData: Decodable {
    let data: CategoryList
    
    struct CategoryList: Decodable {
        let categories: [Category]
    }
    
    struct Category: Decodable {
        let name: String
    }
}

extension CategoriesData: NetworkResponse {}
