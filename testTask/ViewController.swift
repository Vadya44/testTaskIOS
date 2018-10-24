//
//  ViewController.swift
//  testTask
//
//  Created by Вадим Гатауллин on 19/10/2018.
//  Copyright © 2018 Вадим Гатауллин. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu

class ViewController: UITableViewController {
    
    var products : [Product] = []
    let service = PHuntAPIService()
    
    var tempCategory : Category = Category(name : "tech")
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var selectedTitleLabel: UINavigationItem!
    
    var menuView: BTNavigationDropdownMenu!
    
    let topics = ["tech", "books", "google", "marketing", "snapchat", "photography", "payment", "design tools",
                  "developer tools", "social-media tools", "music", "hardware", "batteries"]
    
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        topics.forEach { topic in
            categories.append(Category(name : topic))
        }
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: BTTitle.title("\(topics.first!)↓"), items: topics)
        
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            self!.selectedTitleLabel.title = "\(self!.topics[indexPath])↓"
            self!.tempCategory = self!.categories[indexPath]
            self!.getProducts()
        }
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = UIColor(red: 0.0/255.0, green:160.0/255.0, blue:195.0/255.0, alpha: 0.3)
        menuView.shouldKeepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.white
        menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
        menuView.cellTextLabelAlignment = .center
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.black
        menuView.maskBackgroundOpacity = 0.3
    
        self.navigationItem.titleView = menuView
        
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
        
        if (self.activityIndicator.isAnimating && !products.isEmpty) {
            self.activityIndicator.stopAnimating()
        }
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let prodVC = storyboard?.instantiateViewController(withIdentifier: "productVC") as! ProductViewController
        prodVC.product = products[indexPath.row]
        navigationController?.pushViewController(prodVC, animated: true)
    }

    func getProducts() {
        self.menuView.isUserInteractionEnabled = false
        if (!activityIndicator.isAnimating) {
            products.removeAll()
            self.tableView.reloadData()
        }
        activityIndicator.startAnimating()
        
        self.service.printJson (category : tempCategory) { (res) in
            res.asObservable().subscribe({ (e) in
                if (e.error != nil) {
                    let alertController = UIAlertController(title: "Unable to get data ", message: "Problems with API or Internet connection", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                else if (e.element != nil) {
                    self.products.append(e.element!)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.menuView.isUserInteractionEnabled = true
                    }
                    
                }
                
            })
        }
        
    }
    @IBAction func RefreshButtonPressed(_ sender: Any) {
            getProducts()
    }
    
}

