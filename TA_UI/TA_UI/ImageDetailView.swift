//
//  ImageDetailView.swift
//  TA_UI
//
//  Created by King Kraul on 31/01/2017.
//  Copyright © 2017 Taschenanwalt. All rights reserved.
//

import UIKit

class ImageDetailView:  UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBOutlet weak var Image: UIImageView!
    var imageToShow : UIImage!
    
    
    override func viewDidLoad() {
        
        Image?.image = imageToShow
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
    }
    
    func tapped() {
        performSegue(withIdentifier: "backToOldCases" , sender: Any?.self)
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.ScrollView
    }
    
    
  

}
