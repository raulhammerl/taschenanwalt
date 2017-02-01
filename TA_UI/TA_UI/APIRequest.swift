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
    
    let baseUrl = "https://api.api.ai/v1/query?" //API.AI base url for api requests
    let lang = "de" //German language
    let clientKey = "4315190c91b6490f8868b3acda1542ad" //API.AI client authentication key
    func sendRequest(session: Int, request: String, callback: @escaping (String) -> ())
    {
        let escapedRequest = request.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let queryUrl = baseUrl+"query="+escapedRequest!
        let completeUrl = queryUrl+"&lang="+lang+"&sessionId="+String(session)
        let url = URL(string: completeUrl)
        print(request);
        var urlRequest = URLRequest(url: url!) //make a request out of the URL
        urlRequest.setValue("Bearer "+clientKey, forHTTPHeaderField: "Authorization")//set HTTP auth header
        let session = URLSession.shared
        //perform data request
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            
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
                    if let unfallhergangJson = json["result"]["parameters"]["unfallhergang"].string{
                        self.fall.unfallHergang = unfallhergangJson;
                    }
                    
                    if let done = json["result"]["parameters"]["done"].string{
                        if(done == "" || done == "done"){
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
                    if let zugid = json["result"]["parameters"]["zielbahnhof"].string{
                        self.zug.zugid = zugid;
                    }
                    if let done = json["result"]["parameters"]["done"].string{
                        if(done == "done" || done == ""){
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
                    if let zugid = json["result"]["parameters"]["zielbahnhof"].string{
                        self.zug.zugid = zugid;
                    }
                    if let done = json["result"]["parameters"]["done"].string{
                        if(done == "done" || done == ""){
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
        var jsonDict = ["ID" : id, "Usecase" : allgemein.usecase , "Verletzte" : autounfall.verletzte, "Sachschaden" : autounfall.sachschaden, "Name" : autounfall.name, "Adresse" : autounfall.adresse, "Telefonnummer" : autounfall.telefonnr, "Kennzeichen" : autounfall.kennzeichen, "Datum" : allgemein.datum, "Location" : allgemein.location, "Stadt" : allgemein.locality, "Unfallhergang" : autounfall.unfallHergang];
        for index in 0 ..< allgemein.imageLink.count {
            jsonDict["ImageFile" + String(index)] = allgemein.imageLink[index];
        }
        
        //Dictionary speichern, mit saveFile Function aus FileSaveHelper
        do {
            try jsonFile.saveFile(dataForJson: jsonDict as NSDictionary)
            allgemein.imageLink = [];
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
        var jsonDictZug = ["ID" : id, "Usecase" : allgemein.usecase , "Name" : zugProblem.name, "Adresse" : zugProblem.adresse, "Bankverbindung" : zugProblem.bankverbindung, "Startbahnhof" : zugProblem.startbahnhof, "Zielbahnhof" : zugProblem.zielbahnhof, "Datum" : allgemein.datum, "ZugID" : zugProblem.zugid];
        
        for index in 0 ..< allgemein.imageLink.count {
            jsonDictZug["ImageFile" + String(index)] = allgemein.imageLink[index];
        }
        
        //Dictionary speichern, mit saveFile Function aus FileSaveHelper
        do {
            try jsonFile.saveFile(dataForJson: jsonDictZug as NSDictionary)
            allgemein.imageLink = [];
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
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        return result;
    }
    
}


