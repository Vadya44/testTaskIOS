//
//  ProductViewController.swift
//  testTask
//
//  Created by Вадим Гатауллин on 22/10/2018.
//  Copyright © 2018 Вадим Гатауллин. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productVotesLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productThumbnailImageView: UIImageView!
    
    @IBOutlet weak var navBar: UINavigationItem!
    var product : Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.title = product?.getName()
        productTitleLabel.text = product?.getName()
        productVotesLabel.text = String("\(product?.getVotes() ?? 0) votes")
        productDescriptionLabel.text = product?.getDescription()
        productThumbnailImageView.image = product?.getThumbnail()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let allControllers = NSMutableArray(array: navigationController!.viewControllers)
        allControllers.removeObject(at: allControllers.count - 2)
        self.navigationController!.setViewControllers(allControllers as [AnyObject] as! [UIViewController], animated: false)
    }
    
    @IBAction func openWebClicked(_ sender: Any) {
        UIApplication.shared.openURL((product?.getRedirURL())!)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
