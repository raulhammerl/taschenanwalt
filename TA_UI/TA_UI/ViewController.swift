//
//  ViewController.swift
//  TA_UI
//
//  Created by King Kraul on 08/12/2016.
//  Copyright © 2016 Taschenanwalt. All rights reserved.
//

import UIKit

   let jsonFile:FileSaveHelper = FileSaveHelper(fileName: "jsonFile", fileExtension: .JSON, subDirectory: "SavingFiles", directory: .documentDirectory);

    var idHelper = 0;

    var anzahlImages = idHelper;

    let allgemein = allgemeinFall();



class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
