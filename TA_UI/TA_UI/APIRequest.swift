//
//  APIRequest.swift
//  apiai-request-model
//
//  Created by Sebastian Wagner on 10.12.16.
//  Copyright © 2016 Sebastian Wagner. All rights reserved.
//

import Foundation
import SwiftyJSON

class APIRequest
{
    //let urlEndpoint: String = "http://taschenanwalt.pythonanywhere.com/talk/?msg="
    let urlEndpoint: String = "http://taschenanwalt.pythonanywhere.com/json/?msg="
    
    func sendRequest(request: String, callback: @escaping (String) -> ())
    {
        let escapedRequest = request.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = URL(string: urlEndpoint + escapedRequest!) //create a url out of the endpoint
        print(request);
        print("Url endpoint + request: " + urlEndpoint + escapedRequest!);
        let urlRequest = URLRequest(url: url!) //make a request out of the URL
        let session = URLSession.shared
        //var result = ""
        //perform data request
        let task = session.dataTask(with: urlRequest) { data, response, error in
            // do stuff with response, data & error here
            //var d = data
            //var r = response
            //var e = error
            //result = (data?.base64EncodedString())!
            /*do {
                //let jsonDictionary = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as! [String: Any] //cast to JSON object
                //let fulfillment = jsonDictionary[0]["fulfillment"] as? [String: Any]//get the fulfillment field
                //let speech = fulfillment["speech"] as! String //extract the String response of chatbot
                result = speech
            }
            catch
            {
                //do something
            } */
            //print("result here !")
            //result = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
            if let returnedData = data
            {
                print("Data has been returned.")
                let json = JSON(data: returnedData)
                print(json)
                if let result = json["result"]["fulfillment"]["speech"].string {
                    //Now you got your value
                    print("We've got our value.")
                    print(result)
                    callback(result) //The result will be accessible via the variable resultResponse
                }
            }
            
            //print(result)
            //print("Response here!")
            //print(r)
            //print("Error here!")
            //print(e)
            
        }
        task.resume()
    }
}

