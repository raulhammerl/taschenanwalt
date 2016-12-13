//
//  APIRequest.swift
//  apiai-request-model
//
//  Created by Sebastian Wagner on 10.12.16.
//  Copyright © 2016 Sebastian Wagner. All rights reserved.
//

import Foundation

class APIRequest
{
    let urlEndpoint: String = "http://taschenanwalt.pythonanywhere.com/talk/?msg="
    
    
    func sendRequest(request: String) -> String
    {
        let url = URL(string: urlEndpoint + request) //create a url out of the endpoint
        let urlRequest = URLRequest(url: url!) //make a request out of the URL
        let session = URLSession.shared
        var result = ""
        //perform data request
        let task = session.dataTask(with: urlRequest) { data, response, error in
            // do stuff with response, data & error here
            var d = data
            var r = response
            var e = error
            result = (data?.base64EncodedString())!
            print("result here !")
            result = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
            print(result)
            print("Response here!")
            print(r)
            print("Error here!")
            print(e)
        }
        
        task.resume()
        return result
    }
}
