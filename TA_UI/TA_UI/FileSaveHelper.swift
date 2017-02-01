//
//   FileSaveHelper.swift
//  bspSaveData
//
//  Created by Maria Bittl on 02.01.17.
//  Copyright © 2017 Maria Bittl. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class FileSaveHelper {
    var items = [[String:AnyObject]]()

    convenience init(fileName:String, fileExtension:fileExtension, subDirectory:String){
        self.init(fileName:fileName, fileExtension:fileExtension, subDirectory:subDirectory, directory:.documentDirectory)
    }
    convenience init(fileName:String, fileExtension:fileExtension){
        self.init(fileName:fileName, fileExtension:fileExtension, subDirectory:"", directory:.documentDirectory)
    }
    
    //private enum: Fehlermeldungen, die die Methoden in dieser Klasse erzeugen können (Error Types)
    private enum FileErrors:Error {
        case JsonNotSerialized
        case FileNotSaved
        //error type because the image convert to NSData.
        case ImageNoteConvertedToData
        case FileNotRead
        case FileNotFound
        
    }
    
    //enum, das die File Arten beinhaltet, die in dieser Klasse erlaubt sind (File Extension Types)
    enum fileExtension:String {
        case JSON = ".json"
        case JPG = ".jpg"    }
    
    //Variablen, die es erlauben mit dem benötigten File zu interagieren (private properties)
    private let directory:FileManager.SearchPathDirectory
    private let directoryPath: String
    private let fileManager = FileManager.default
    private var fileName:String
    private let filePath:String
    private let fullyQualifiedPath:String
    private let subDirectory:String
    
    
    //2 Bools, mit denen überprüft werden kann, ob der File oder Directory existiert. Verwendet den default file manager, um zu überprüfen ob sie existieren
    var fileExists:Bool {
        get {
            return fileManager.fileExists(atPath: fullyQualifiedPath)
            print(fullyQualifiedPath)
        }
    }
  
    var directoryExists:Bool {
        get {
            var isDir = ObjCBool(true)
            return fileManager.fileExists(atPath: filePath, isDirectory: &isDir )
        }
    }
    
    //Init mit vier Parametern. 
    //fileName: Name des Files, fileExtension: Dateieindung, die der File benutzt, subDirectory: Name der Sub Directory, in der der File gespeichert wird, directory: Directory, in der die Sub Directory/File gespeichert wird
    init(fileName:String, fileExtension:fileExtension, subDirectory:String, directory:FileManager.SearchPathDirectory){
        self.fileName = fileName + fileExtension.rawValue
        self.subDirectory = "/\(subDirectory)"
        self.directory = directory
        //directoryPath: beinhaltet den aktuellen Pfad der Directory, die der Nutzer  passed in
        self.directoryPath = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true)[0]
        self.filePath = directoryPath + self.subDirectory
        self.fullyQualifiedPath = "\(filePath)/\(self.fileName)"

        print(self.directoryPath)
        createDirectory()
    }
    //Directory wird angelegt
    private func createDirectory(){
    
        if !directoryExists {
            do {
                try fileManager.createDirectory(atPath: filePath, withIntermediateDirectories: false, attributes: nil)
            }
            catch {
                print("An Error was generated creating directory")
            }
        }
    }

    //dem saveFile wird als Datentyp AnyObject übergeben --> es können Arrays,String, Dictionarys übergeben werden, die als JSON gespeichert werden
    func saveFile(dataForJson:AnyObject) throws{
       //1. Existiert der File true/false
        //false:
        if (fileExists == false)  {
            print("File exisitiert nicht");
            do {
                //File wird erzeugt mit createFile(atPath, content, attributes) Content wird erst später hinzugefügt. Attributes, um File Permissions zu setzen
                if !fileManager.createFile(atPath: fullyQualifiedPath, contents: nil, attributes: nil){
                    throw FileErrors.FileNotSaved
                }
            print("File exisitiert jetzt");

            } catch {
                print(error)
                throw FileErrors.FileNotSaved
            }
        }
        //true
        if (fileExists == true)  {
            print("File exisitiert ");
        //Daten werden in das bereits erzeugte File gespeichert
        do {
            //convertObjectToData, um ein Objekt in pretty JSON Format zu erhalten
            let jsonData = try convertObjectToData(data: dataForJson)
            let data = try NSData(contentsOfFile: fullyQualifiedPath, options: NSData.ReadingOptions.mappedIfSafe)
            print(data);
            let jsonDictionaryNeu = try JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments) as! NSDictionary
            
            items.append(jsonDictionaryNeu as! [String : AnyObject]);
            print(items);
            
            let result = try convertObjectToData(data: items as AnyObject);
            do {
                let file = FileHandle(forWritingAtPath: fullyQualifiedPath)
                file?.write(result as Data)
                print("JSON data was written to the file successfully!")
            }
        } catch {
            //Catch, print, and throw an error.
            print(error)
            throw FileErrors.FileNotSaved
        }
        }
            
    }
    
    //Funktion, um ein Bild zu speichern, bekommt als Übergabewert ein UIImage
    func saveFileImage(image:UIImage) throws {
        //UIImage in NSData umwandeln: mit  UIImageJPEGRepresentation(_:_:) Methode, mit image und scale factor als Argumente. Funktioniert nur mit JPEG Images
        guard let data = UIImageJPEGRepresentation(image, 1.0) else {
            throw FileErrors.ImageNoteConvertedToData
        }
        
        //Image Link wird einem Array hinzugefügt, das Array wird mit allen anderen Daten in Json File gespeichert, um die Bilder den Fällen zuweisen zu können
        let file = fullyQualifiedPath
        allgemein.imageLink.append(file);
        print("file: " + file)
        //File wird gespeichert. createFile(filepath, data, attributes).Es gibt einen boolean Wert zurück, falls dieser false ist, wird ein Fehler angezeigt
        if !fileManager.createFile(atPath: fullyQualifiedPath, contents: data, attributes: nil){
            throw FileErrors.FileNotSaved
            
        }
    }
    
    //Daten werden serialisiert in JSON. Rückgabewert ist ein NSData Objekt
    private func convertObjectToData(data:AnyObject) throws -> NSData {
        do {
            //Wandelt AnyObject in NSData um, indem NSJSONSerialization verwendet wird. ".PrettyPrinted" wird verwendet um den Text in ein leicht lesbares Format umzuwandeln
            let newData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            return newData as NSData
        }
        catch {
            print("Error writing data: \(error)")
        }
        throw FileErrors.JsonNotSerialized
    }

    //gespeichertes Bild anzeigen lassen
    func getImage(imagePath:String) throws -> UIImage {
        print("imagePath: " + imagePath)
        
        var imageFileExists:Bool {
            get {
                return fileManager.fileExists(atPath: imagePath)
                print(imagePath)
            }
        }
        if(imageFileExists == false){
            throw FileErrors.FileNotFound
        }
       
       let path = imagePath
        guard let image = UIImage(contentsOfFile: path) else {
            throw FileErrors.FileNotRead
        }
        return image
    }
    
//Wird nicht benutzt, da in der json Datei ein Array gespeichert wird --> wird mit swifty Json ausgelesen
    func getJSONData() throws -> JSON {
        guard fileExists else {
            throw FileErrors.FileNotFound
        }
        do {
           
            let data = try NSData(contentsOfFile: fullyQualifiedPath, options: NSData.ReadingOptions.mappedIfSafe)
            let jsonData = JSON(data: data as Data);

            return jsonData
        } catch {
            throw FileErrors.FileNotRead
        }
    }
    
    
    //Erzeugt ID (Int) für jeden einzelnen Fall, der in der json Datei gespeichert wird. Wird in APIRequest als Id übergeben
    func getId() throws -> Int{
        var id = 0;
        if(fileExists == true){
            do{
                //Daten aus der jsonDatei vom Typ NSData
                let jsonData = try NSData(contentsOfFile: fullyQualifiedPath, options: NSData.ReadingOptions.mappedIfSafe)
                //Daten aus der jsonDatei vom Typ Data
                let jsonOwn = JSON(data: jsonData as Data);
                //Anzahl der eingetragenen Autounfälle
                id = jsonOwn.count;
            }catch {
                print(error);
            }
        }else{
            //Falls File noch nicht exisitiert, wird id auf 0 gesetzt, damit der erste Eintrag die ID 0 hat
            id = 0;
        }
        //Rückgabewert id (Int)
        return id;
    }
    

}
  
