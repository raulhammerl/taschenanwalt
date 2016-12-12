//
//  ViewController.swift
//  apiai-request-model
//
//  Created by Sebastian Wagner on 10.12.16.
//  Copyright © 2016 Sebastian Wagner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let req: APIRequest = APIRequest()
        print("This is the response from the sendRequest function: " + req.sendRequest(request: "autounfall"))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

