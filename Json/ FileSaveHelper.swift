//
//   FileSaveHelper.swift
//  bspSaveData
//
//  Created by Maria Bittl on 02.01.17.
//  Copyright © 2017 Maria Bittl. All rights reserved.
//

import Foundation
import UIKit

class FileSaveHelper {
    var items = [[String:AnyObject]]()
    
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
    private let fileName:String
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
   
    private func createDirectory(){
       

        if !directoryExists {
            do {
                //2
                try fileManager.createDirectory(atPath: filePath, withIntermediateDirectories: false, attributes: nil)
            }
            catch {
                print("An Error was generated creating directory")
            }
        }
    }
    

    //overload the saveFile method to allow AnyObject as the data type -> pass in Arrays, Strings, or Dictionarys and save them as JSON. Again, the method is marked as throws.
    func saveFile(dataForJson:AnyObject) throws{
        do {
            //convertObjectToData to get object in a pretty JSON data format 
            //use attributes to set file permissions
            let jsonData = try convertObjectToData(data: dataForJson)
            if !fileManager.createFile(atPath: fullyQualifiedPath, contents: jsonData as Data, attributes: nil){
                throw FileErrors.FileNotSaved
            }
        } catch {
            //Catch, print, and throw an error.
            print(error)
            throw FileErrors.FileNotSaved
        }
        
    }
    
    //The saveFile method has been overloaded to take UIImage as a parameter.
    func saveFileImage(image:UIImage) throws {
        //To convert the UIImage to NSData. This is done using UIImageJPEGRepresentation(_:_:) method. It takes the image and the scale factor as arguments. This will only work with JPEG images. You can use PNG, but you’ll have to specify that in your file extension enum and use UIImagePNGRepresentation(_:). This is wrapped in a guard statement. If the conversion fails, we throw an error.
        guard let data = UIImageJPEGRepresentation(image, 1.0) else {
            throw FileErrors.ImageNoteConvertedToData
        }
        //Now we’ll save the file. The createFile takes the file path, data, and attributes as arguments. It does not throw, but returns a bool. If it returns false, we’ll throw our error.
        if !fileManager.createFile(atPath: fullyQualifiedPath, contents: data, attributes: nil){
            throw FileErrors.FileNotSaved
        }
    }
 
    //Serialize data into JSON. The method convertObjectToData will return a NSData object and throws an error.
    private func convertObjectToData(data:AnyObject) throws -> NSData {
        
        do {
            //Convert AnyObject to NSData using NSJSONSerialization. the .PrettyPrinted will format the text in an easy to read format.
            let newData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            return newData as NSData
        }
        //Catch, print, and throw an error.
        catch {
            print("Error writing data: \(error)")
        }
        throw FileErrors.JsonNotSerialized
    }
    
    func getImage() throws -> UIImage {
        guard fileExists else {
            throw FileErrors.FileNotFound
        }
        
        guard let image = UIImage(contentsOfFile: fullyQualifiedPath) else {
            throw FileErrors.FileNotRead
        }
        
        return image
    }
    
    // 1
    
  
    // 1
    func getJSONData() throws -> NSDictionary {
        // 2
        guard fileExists else {
            throw FileErrors.FileNotFound
        }
        
        do {
            // 3
            let data = try NSData(contentsOfFile: fullyQualifiedPath, options: NSData.ReadingOptions.mappedIfSafe)
            // 4
            let jsonDictionary = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! NSDictionary
            items.append(jsonDictionary as! [String : AnyObject]);
            return jsonDictionary
        } catch {
            throw FileErrors.FileNotRead
        }
    }}

