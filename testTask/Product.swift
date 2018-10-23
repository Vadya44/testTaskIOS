//
//  Product.swift
//  testTask
//
//  Created by Вадим Гатауллин on 20/10/2018.
//  Copyright © 2018 Вадим Гатауллин. All rights reserved.
//

import Foundation
import UIKit


struct Product {
    private let name : String
    private let description : String
    private let votes : Int
    private let thumbnail : UIImage
    private let redirURL : URL
    
    init(name : String, description : String, votes : Int, thumbnail  : UIImage,
         redirURL : URL) {
        self.name = name
        self.description = description
        self.votes = votes
        self.thumbnail = thumbnail
        self.redirURL = redirURL
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getDescription() -> String {
        return self.description
    }
    
    func getVotes() -> Int {
        return self.votes
    }
    
    func getThumbnail() -> UIImage {
        return self.thumbnail
    }
    
    func getRedirURL() -> URL {
        return self.redirURL
    }
}
