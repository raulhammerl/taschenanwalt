//
//  ViewController.swift
//  bspSaveData
//
//  Created by Maria Bittl on 02.01.17.
//  Copyright © 2017 Maria Bittl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    
    @IBOutlet var eingabe1: UITextField!
    @IBOutlet var eingabe2: UITextField!

    @IBOutlet var buttonWeiter: UIButton!
    
    var value1 = "";
    var value2 = "";
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
        
                
        eingabe1.text = "";
        eingabe2.text = "";
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "uebergabeButton"
        {
            let destinationVC = segue.destination as! ViewControllerAusgabe
            destinationVC.uebergabe1 = eingabe2.text!;
            destinationVC.uebergabe2 = eingabe1.text!;
            
        }
    }
    
    
    

    
   @IBAction func changeEingabe1(_ sender: AnyObject) {
        if eingabe1.text != nil {
           
             value1 = eingabe1.text!;
            //text.text = value;
        }
        
    }

    @IBAction func changeEingabe2(_ sender: AnyObject) {
        if eingabe2.text != nil {
             value2 = eingabe2.text!;
            //text1.text = value;
        }
    }
  
  
    
}

