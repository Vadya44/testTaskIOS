//
//  ViewController.swift
//  testTask
//
//  Created by Вадим Гатауллин on 19/10/2018.
//  Copyright © 2018 Вадим Гатауллин. All rights reserved.
//

import UIKit
import SwiftyJSON
import RxSwift
import RxCocoa
import Alamofire
import RxAlamofire
import BTNavigationDropdownMenu

class ViewController: UITableViewController {
    
    var products : [Product] = []
    let service = PHuntAPIService()
    
    var container: UIView = UIView()
    let activityView = UIActivityIndicatorView(style: .whiteLarge)
    
    @IBOutlet weak var selectedTitleLabel: UINavigationItem!
    
    var menuView: BTNavigationDropdownMenu!
    
    let topics = ["tech", "books", "google", "marketing", "snapchat", "photography", "payment", "design tools",
                  "developer tools", "social-media tools", "music", "hardware", "batteries"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.selectedTitleLabel.title = topics.first
        self.navigationController?.navigationBar.isTranslucent = true
        
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: BTTitle.title(topics.first!), items: topics)
        
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            self?.selectedTitleLabel.title = self?.topics[indexPath]
        }
        
        self.navigationItem.titleView = menuView
        
        
        getProducts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductTableViewCell
        let temp : Product = products[indexPath.row]
        
        
        
        cell.NameLabel.text = temp.getName()
        cell.VotesLabel.text = "\(temp.getVotes()) votes"
        cell.DescriptionLabel.text = temp.getDescription()
        cell.ThumbnailImage.image = temp.getThumbnail()
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let prodVC = storyboard?.instantiateViewController(withIdentifier: "productVC") as! ProductViewController
        prodVC.product = products[indexPath.row]
        
        navigationController?.pushViewController(prodVC, animated: true)
    }

    func getProducts() {
        container.frame = CGRect(x: 0, y: 0, width: 80, height: 80) // Set X and Y whatever you want
        container.backgroundColor = .clear
        
        activityView.center = self.view.center
        activityView.startAnimating()
        
        
        container.addSubview(activityView)
        self.view.addSubview(container)
        activityView.startAnimating()
        
        DispatchQueue.main.async {
            self.service.printJson { (res) in
            res.asObservable().subscribe({ (e) in
                self.activityView.stopAnimating()
                self.activityView.removeFromSuperview()
                if (e.error != nil) {
                    let alertController = UIAlertController(title: "Unable to get data ", message: "Problems with API or Internet connection", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                else if (e.element != nil) {
                    self.products.append(e.element!)
                    self.tableView.reloadData()
                }
                
            })
        }
        }
    }
    @IBAction func RefreshButtonPressed(_ sender: Any) {
        getProducts()
    }
    
}

