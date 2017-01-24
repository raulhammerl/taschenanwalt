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
  //  var saveFileContent = [[String:AnyObject]]()
  

    //keyword convenience. This lets the compiler know that we will be calling our designated init from this method. Also, there are fewer parameters in the method. When we use this init, we won’t have to specify the directory.
    //init that specifies  the directory.
    convenience init(fileName:String, fileExtension:fileExtension, subDirectory:String){
        
        // This is the call to the designated init.
        // defaulting to the Document directory. You can set this up to be any directory you want, or you can create convenience inits for both directories, if you want.
        self.init(fileName:fileName, fileExtension:fileExtension, subDirectory:subDirectory, directory:.documentDirectory)
    }
    convenience init(fileName:String, fileExtension:fileExtension){
        self.init(fileName:fileName, fileExtension:fileExtension, subDirectory:"", directory:.documentDirectory)
    }
    
    //A private enum for the errors that the methods in this class can throw.
    // MARK:- Error Types
    private enum FileErrors:Error {
        case JsonNotSerialized
        case FileNotSaved
        //a new error type because the image convert to NSData.
        case ImageNoteConvertedToData
        case FileNotRead
        case FileNotFound
        
    }
    
    //Create an enum to contain the file types allowed by this class.
    // MARK:- File Extension Types
    enum fileExtension:String {
        case JSON = ".json"
        case JPG = ".jpg"    }
    
    //The majority of the properties in this class are private. They will allow to interact with the file as need. more in initializers.
    // MARK:- Private Properties
    private let directory:FileManager.SearchPathDirectory
    private let directoryPath: String
    private let fileManager = FileManager.default
     var fileName:String
    private let filePath:String
    private let fullyQualifiedPath:String
    private let subDirectory:String
    
    
    //two Bools if the file exists or if the directory exists. They are computed properties and use the default file manager to check if they exist.
    var fileExists:Bool {
        get {
            return fileManager.fileExists(atPath: fullyQualifiedPath)
        }
    }
    
    var directoryExists:Bool {
        get {
            var isDir = ObjCBool(true)
            return fileManager.fileExists(atPath: filePath, isDirectory: &isDir )
        }
    }
    
    
    
    //It takes four parameters:
    //1. fileName: The name of the file.
    //2. fileExtension: The extension the file is going to use. This will be provided using the enum FileExtension.
    //3. subDirectory: The name of the sub directory where we will save the file.
    //4. directory: The directory the file will be saved in.
    
    init(fileName:String, fileExtension:fileExtension, subDirectory:String, directory:FileManager.SearchPathDirectory){
        self.fileName = fileName + fileExtension.rawValue
        self.subDirectory = "/\(subDirectory)"
        self.directory = directory
        //Setup all the other variables too. The directoryPath will get the actual path of the directory the user passed in. The filePath is going to be the directoryPath and the subDirectory combined. The fullyQualifiedPath will include the fileName with the path.
        self.directoryPath = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true)[0]
        self.filePath = directoryPath + self.subDirectory
        self.fullyQualifiedPath = "\(filePath)/\(self.fileName)"
        //Prints the path for the document folder
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
    
    
    //overload the saveFile method to allow AnyObject as the data type -> pass in Arrays, Strings, or Dictionarys and save them as JSON. Again, the method is marked as throws.
    func saveFile(dataForJson:AnyObject) throws{
       //1. Existiert der File true/false
        //false:
        if (fileExists == false)  {
            print("File exisitiert nicht");
            do {
                //convertObjectToData to get object in a pretty JSON data format
                //use attributes to set file permissions
                // let jsonData = try convertObjectToData(data: dataForJson)
                //File wird erzeugt mit createFile(atPath, content, attributes, Content wird erst später hinzugefügt
                if !fileManager.createFile(atPath: fullyQualifiedPath, contents: nil, attributes: nil){
                    throw FileErrors.FileNotSaved
                }
            print("File exisitiert jetzt");

            } catch {
                //Catch, print, and throw an error.
                print(error)
                throw FileErrors.FileNotSaved
            }
        }
        //true
        if (fileExists == true)  {
            print("File exisitiert ");
        //Daten werden in das bereits erzeugte File gespeichert
        do {
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
        //To convert the UIImage to NSData. This is done using UIImageJPEGRepresentation(_:_:) method. It takes the image and the scale factor as arguments. This will only work with JPEG images. You can use PNG, but you’ll have to specify that in your file extension enum and use UIImagePNGRepresentation(_:). This is wrapped in a guard statement. If the conversion fails, we throw an error.
        guard let data = UIImageJPEGRepresentation(image, 1.0) else {
            throw FileErrors.ImageNoteConvertedToData
        }
        //Hier wird der File gespeichert. createFile(filepath, data, attributes).Es gibt einen boolean Wert zurück, falls dieser false ist, wird ein Fehler angezeigt
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
    func getImage() throws -> UIImage {
        guard fileExists else {
            throw FileErrors.FileNotFound
        }
        
        guard let image = UIImage(contentsOfFile: fullyQualifiedPath) else {
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
  
