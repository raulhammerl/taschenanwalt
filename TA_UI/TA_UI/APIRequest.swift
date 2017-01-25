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
    let fall = Faelle();
    let zug = zugFall();
    //let urlEndpoint: String = "http://taschenanwalt.pythonanywhere.com/talk/?msg="
    //let urlEnvarint: String = "http://taschenanwalt.pythonanywhere.com/json/?msg="
    let baseUrl = "https://api.api.ai/v1/query?" //API.AI base url for api requests
    let sessionId = 12345 //TODO: Generate a new session ID
    let lang = "de" //German language
    let clientKey = "4315190c91b6490f8868b3acda1542ad" //API.AI client authentication key
    //var idHelper = 0;
    func sendRequest(request: String, callback: @escaping (String) -> ())
    {
        let escapedRequest = request.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        //let url = URL(string: urlEnvarint + escapedRequest!) //create a url out of the endpoint
        let queryUrl = baseUrl+"query="+escapedRequest!
        //let completeUrl = baseUrl + "query="+escapedRequest!+"&lang="+lang+"&sessionId="+sessionId
        let completeUrl = queryUrl+"&lang="+lang+"&sessionId="+String(sessionId)
        let url = URL(string: completeUrl)
        print(request);
        //print("Url endpoint + request: " + urlEnvarint + escapedRequest!);
        var urlRequest = URLRequest(url: url!) //make a request out of the URL
        urlRequest.setValue("Bearer "+clientKey, forHTTPHeaderField: "Authorization")//set HTTP auth header
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
           
            
            //Json Datei, erzeugt von Chatbot, wird hier ausgelesen
            if let returnedData = data
            {
                print("Data has been returned.")
                let json = JSON(data: returnedData)
                let datum = self.aktuellesDatum();
                allgemein.datum = datum;
                allgemein.identi = idHelper;
                
                if let usecaseJson = json["result"]["parameters"]["usecase"].string{
                    allgemein.usecase = usecaseJson;
                }
                
                if(allgemein.usecase == "autounfall"){
                
                    if let verletzteJson = json["result"]["parameters"]["verletzte"].string{
                        self.fall.verletzte = verletzteJson;
                    }
                    if let sachschadenJson = json["result"]["parameters"]["sachschaden"].string{
                        self.fall.sachschaden = sachschadenJson;
                    }
                    if let alkoholJson = json["result"]["parameters"]["alkohol"].string{
                        self.fall.alkohol = alkoholJson;
                    }
                    if let auslandJson = json["result"]["parameters"]["ausland"].string{
                        self.fall.ausland = auslandJson;
                    }
                    if let autobahnJson = json["result"]["parameters"]["autobahn"].string{
                        self.fall.autobahn = autobahnJson;
                    }
                    if let nameJson = json["result"]["parameters"]["name"].string{
                        self.fall.name = nameJson;
                    }
                    if let adresseJson = json["result"]["parameters"]["adresse"].string{
                        self.fall.adresse = adresseJson;
                    }
                    if let telefonnrJson = json["result"]["parameters"]["telefonnr"].string{
                        self.fall.telefonnr = telefonnrJson;
                    }
                    if let kennzeichenJson = json["result"]["parameters"]["kennzeichen"].string{
                        self.fall.kennzeichen = kennzeichenJson;
                    }
                    if let done = json["result"]["parameters"]["done-variable"].string{
                        if(done == "done" ){
                            self.saveInJsonAutounfall(autounfall: self.fall);
                        }
                    }
                }
                if(allgemein.usecase == "zugausfall"){
                    if let nameBahnJson = json["result"]["parameters"]["name"].string{
                        self.zug.name = nameBahnJson;
                    }
                    if let adresseBahnJson = json["result"]["parameters"]["adresse"].string{
                        self.zug.adresse = adresseBahnJson;
                    }
                    if let bankverbindungBahnJson = json["result"]["parameters"]["bankverbindung"].string{
                        self.zug.bankverbindung = bankverbindungBahnJson;
                    }
                    if let startbahnhofBahnJson = json["result"]["parameters"]["startbahnhof"].string{
                        self.zug.startbahnhof = startbahnhofBahnJson;
                    }
                    if let zielbahnhofBahnJson = json["result"]["parameters"]["zielbahnhof"].string{
                        self.zug.zielbahnhof = zielbahnhofBahnJson;
                    }
                    if let done = json["result"]["parameters"]["done-variable"].string{
                        if(done == "done" ){
                            self.saveInJsonZug(zugProblem: self.zug);
                        }
                    }
                }
                if(allgemein.usecase == "zugverspätung"){
                    if let nameBahnJson = json["result"]["parameters"]["name"].string{
                        self.zug.name = nameBahnJson;
                    }
                    if let adresseBahnJson = json["result"]["parameters"]["adresse"].string{
                        self.zug.adresse = adresseBahnJson;
                    }
                    if let bankverbindungBahnJson = json["result"]["parameters"]["bankverbindung"].string{
                        self.zug.bankverbindung = bankverbindungBahnJson;
                    }
                    if let startbahnhofBahnJson = json["result"]["parameters"]["startbahnhof"].string{
                        self.zug.startbahnhof = startbahnhofBahnJson;
                    }
                    if let zielbahnhofBahnJson = json["result"]["parameters"]["zielbahnhof"].string{
                        self.zug.zielbahnhof = zielbahnhofBahnJson;
                    }
                    if let done = json["result"]["parameters"]["done-variable"].string{
                        if(done == "done" ){
                            self.saveInJsonZug(zugProblem: self.zug);
                        }
                    }
                    
                }

              
                if let result = json["result"]["speech"].string {
                    //Now you got your value
                    print("The value from result.speech was retrieved and is: ")
                    print(result)
                    callback(result) //The result will be accessible via the variable resultResponse
                }
            }
            
        }
        task.resume()
    }
    
    func saveInJsonAutounfall(autounfall: Faelle){
        
        let x : Int = allgemein.identi;
        let id = String(x);
   
        //Dictionary für json Datei
        let jsonDict = ["ID" : id, "Usecase" : allgemein.usecase , "Verletzte" : autounfall.verletzte, "Sachschaden" : autounfall.sachschaden, "Alkohol" : autounfall.alkohol, "Ausland" : autounfall.ausland, "Autobahn" : autounfall.autobahn, "Name" : autounfall.name, "Adresse" : autounfall.adresse, "Telefonnummer" : autounfall.telefonnr, "Kennzeichen" : autounfall.kennzeichen, "Datum" : allgemein.datum, "Location" : allgemein.location];
        
        //Dictionary speichern, mit saveFile Function aus FileSaveHelper
        do {
            try jsonFile.saveFile(dataForJson: jsonDict as NSDictionary)
        }
        catch {
            print(error)
        }
        
        
        //Print out whether the file exists.
        print("JSON file exists: \(jsonFile.fileExists)")
        
        do{
            try idHelper = jsonFile.getId();
        }
        catch{
            print(error);
        }
        
    }
    
    
    //speichert Zugfall in json File
    func saveInJsonZug(zugProblem: zugFall){
   
        let x : Int = allgemein.identi;
        let id = String(x);
        
       //Dictionary für json Datei
        let jsonDictZug = ["ID" : id, "Usecase" : allgemein.usecase , "Name" : zugProblem.name, "Adresse" : zugProblem.adresse, "Bankverbindung" : zugProblem.bankverbindung, "Startbahnhof" : zugProblem.startbahnhof, "Zielbahnhof" : zugProblem.zielbahnhof, "Datum" : allgemein.datum];
        
        //Dictionary speichern, mit saveFile Function aus FileSaveHelper
        do {
            try jsonFile.saveFile(dataForJson: jsonDictZug as NSDictionary)
        }
        catch {
            print(error)
        }
        
        
        //Zeigt ob File exisitiert
        print("JSON file exists: \(jsonFile.fileExists)")
        
        do{
            try idHelper = jsonFile.getId();
        }
        catch{
            print(error);
        }        
    }

  //aktuelles Datum + Uhrzeit
    func aktuellesDatum() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy hh:mm"
        let result = formatter.string(from: date)
        return result;
    }
    
}


