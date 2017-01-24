//
//  UsecaseStore.swift
//  TA_UI
//
//  Created by admin on 23.01.17.
//  Copyright © 2017 Taschenanwalt. All rights reserved.
//

import UIKit

class UsecaseStore: NSObject {
    
    var name: String
    var content: String
    
    init (name: String, content: String) {
        self.name = name
        self.content = content
    }
    
}

