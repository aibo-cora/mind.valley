//
//  Categories.swift
//  MindValley
//
//  Created by Yura on 6/30/22.
//

import Foundation

struct CategoriesData: Codable {
    let data: CategoryList
    
    struct CategoryList: Codable {
        let categories: [Category]
    }
    
    struct Category: Codable {
        let name: String
    }
}

extension CategoriesData: NetworkResponse {
    func write(to url: URL?) throws {
        if let url = url {
            try (JSONEncoder().encode(self)).write(to: url)
        }
    }
}
