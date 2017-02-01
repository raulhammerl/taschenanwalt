//
//  DictionaryDetailsViewController.swift
//  TA_UI
//
//  Created by admin on 22.01.17.
//  Copyright © 2017 Taschenanwalt. All rights reserved.
//

import UIKit

class DictionaryDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var details: UILabel!
   
    @IBOutlet weak var text: UILabel!
    
    var content: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

       if let detailsText = content
        {
            details.text = detailsText
        }
        
        text?.text = content
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
