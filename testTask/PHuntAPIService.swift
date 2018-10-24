//
//  PHuntApiService.swift
//  testTask
//
//  Created by Вадим Гатауллин on 20/10/2018.
//  Copyright © 2018 Вадим Гатауллин. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire
import SwiftyJSON

class PHuntAPIService {
    
    
    init() {
        
    }

    // struct for constants - headers and api's url
    private struct Constants {
        static let HTTPHeaders = ["Authorization" : "Bearer 591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff"]
    }
    
    func printJson(category : Category, callback: @escaping (Observable<Product>) -> Void) {
        request(category.getURL() , method : .get, encoding: JSONEncoding.default, headers: Constants.HTTPHeaders)
            .responseJSON(queue: DispatchQueue.global(qos: .background)) { response in
                switch response.result {
                case .success(let value):
                    let seq = self.parseJSONtoBoard(value: value)
                    callback(seq)
                case .failure(_):
                    callback(Observable.error(NSError(domain: "My domain", code: -1, userInfo: nil)))
                }
        }
    }
    
    func parseJSONtoBoard(value : Any) -> Observable<Product> {
        
        let JSONDictionary = value as! Dictionary<String, Any>
        let JSON = JSONDictionary["posts"] as! NSArray
        var productsFromAPi : [Product] = []
        
        for currentProduct in JSON {
            let productAsDictionary = currentProduct as! Dictionary<String, Any>
            
            let productName = productAsDictionary["name"] as! String
            let productURL = productAsDictionary["redirect_url"] as! String
            let productThumbnail = productAsDictionary["thumbnail"] as! Dictionary<String, Any>
            let productThumbnailURL = productThumbnail["image_url"] as! String
            let productTagline = productAsDictionary["tagline"] as! String
            let productVotes = productAsDictionary["votes_count"] as! NSNumber
            
            let imageUrl = URL(string: productThumbnailURL)!
            let imageData = try! Data(contentsOf: imageUrl)
            let productImage = UIImage(data: imageData)
            
            
            let parsedProduct = Product(name: productName, description: productTagline, votes: Int(truncating: productVotes), thumbnail: productImage!, redirURL: URL(string : productURL)!)
            
            productsFromAPi.append(parsedProduct)
        }
        let seq = Observable<Product>.from(productsFromAPi)
        return seq
        
    }
    
    
    
    
}


