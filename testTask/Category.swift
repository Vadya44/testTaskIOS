//
//  Category.swift
//  testTask
//
//  Created by Вадим Гатауллин on 25/10/2018.
//  Copyright © 2018 Вадим Гатауллин. All rights reserved.
//

import Foundation

struct Category {
    let name : String
    let url : String
    init(name : String) {
        self.name = name
        self.url = "https://api.producthunt.com/v1/posts/all?search[category]=\(name)"
    }
    
    func getName() -> String {
        return name
    }
    
    func getURL() -> String {
        return url
    }
}
