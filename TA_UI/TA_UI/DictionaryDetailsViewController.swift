//
//  DictionaryDetailsViewController.swift
//  TA_UI
//
//  Created by admin on 22.01.17.
//  Copyright © 2017 Taschenanwalt. All rights reserved.
//

import UIKit

class DictionaryDetailsViewController: UIViewController {
    
   
    @IBOutlet weak var image: UIImageView!
   
    @IBOutlet weak var text: UILabel!
    
    @IBOutlet weak var headline: UILabel!
    
    var content: String!
    var logo: UIImage!
    var headlineText: String!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        text?.text = content
        image?.image = logo
        headline?.text = headlineText
        
    }
    
  
}
