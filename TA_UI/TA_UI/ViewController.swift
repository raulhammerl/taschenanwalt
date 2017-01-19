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


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    
     /* Buttons für Photo Library/Kamera öffnen/Speichern + ImageView zum Anzeigen des ausgewählten Bildes
     --> fehlt alles noch im Storyboard */
     @IBOutlet weak var PhotoLibrary: UIButton!
     @IBOutlet weak var Camera: UIButton!
     @IBOutlet weak var Save: UIButton!
     @IBOutlet weak var ImageDisplay: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
               // Do any additional setup after loading the view, typically from a nib.
        //Create the jsonFile object.
        
     
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
    
    
     /* Foto aus Photo Library auswählen */
     @IBAction func PhotoLibraryAction(_ sender: UIButton) {
     
     if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
     
     let picker = UIImagePickerController()
     picker.delegate = self
     picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
     picker.allowsEditing = true;
     self.present(picker, animated: true, completion: nil)
     
     }
     }
     
     /* Kamera öffnen und neues Foto machen */
     @IBAction func CameraAction(_ sender: UIButton) {
     
     if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
     
     let picker = UIImagePickerController()
     picker.delegate = self
     picker.sourceType = UIImagePickerControllerSourceType.camera
     picker.allowsEditing = false;
     self.present(picker, animated: true, completion: nil)
     
     }
     }
     
     /* Ausgewähltes Foto in Image View anzeigen */
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
     
     ImageDisplay.image = image
     self.dismiss(animated: true, completion: nil)
     
     }
     
     /* Foto speichern */
     @IBAction func SaveAction(_ sender: UIButton) {
     
     let image = UIImageJPEGRepresentation(ImageDisplay.image!, 0.6)
     let compressedImage = UIImage(data: image!)
     UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
     
     }
     
    
    
}
