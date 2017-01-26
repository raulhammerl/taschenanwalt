//
//  ViewController.swift
//  
//
//  Created by King Kraul on 08/12/2016.
//
//

import UIKit
import JSQMessagesViewController
import CoreLocation
import SwiftyJSON

class ChatViewController: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    
    // dark blue (red: 56/255, green: 77/255, blue: 100/255, alpha: 1.0)
    // light grey (red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
    // orange1 UIColor(red: 243/255, green: 156/255, blue: 18/255, alpha: 1.0)
    var anzahlImages = 1;

    var messages = [JSQMessage]()
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    var api = APIRequest()
    
    var locationManager : CLLocationManager!
    var location : CLLocation!
    var address : String!
    
    override func viewWillAppear(_ animated: Bool) {
       self.collectionView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SETUP
        self.senderId = "123" //Sollte man vllt noch ändern
        self.senderDisplayName = "abc"
        self.setup()
        self.addWelcomeMessage()
        //self.finishReceivingMessage()
        
        //make avatars size zero
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        // Location Manager instanziieren und konfigurieren
        locationManager = CLLocationManager()
        locationManager.delegate = self     // Zugriff auf die eigene Instanz des ViewControllers
        locationManager.desiredAccuracy = kCLLocationAccuracyBest   // Mit bestmöglicher Genauigkeit
        locationManager.requestWhenInUseAuthorization()     // Frage nach Erlaubnis (nur wenn die App in Benutzung ist)
        locationManager.startUpdatingLocation()     // Manager starten
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor(red: 243/255, green: 156/255, blue: 18/255, alpha: 1.0))
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor(red: 56/255, green: 77/255, blue: 100/255, alpha: 1.0))
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func reloadMessagesView() {
        self.collectionView?.reloadData()
    }
    
    
    //override avatars with nil
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
  //file messages/bubbles with content
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }

    //get number of messeges to be displayed
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    //choose outgoing or ingoin for messages
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    //send messages
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    //send a message with media item
    private func addMediaMessage(withId id: String, name: String, media: JSQMessageMediaData)
    {
        if let message = JSQMessage(senderId: id, displayName: name, media: media)
        {
            messages.append(message)
        }
        
    }
    
    // Funktion, die bei jeder Positionsänderung automatisch aufgerufen wird
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations[0] // Erstes Element des Arrays enthält die zuletzt gespeicherte Location
        self.getAdress()
    }
    
    //send button handling
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        /*let messageItem = [
            "senderId": senderId!,
            "senderName": senderDisplayName!,
            "text": text!,
            ]*/
        
        self.addMessage(withId: senderId, name: senderDisplayName, text: text)
        //Show typing indicator
        self.showTypingIndicator = 	true
        //Get the response from the chat bot
        api.sendRequest(request: text) { (result) -> Void in
                self.showTypingIndicator = 	false
                self.addMessage(withId: "321", name: "Chatbot", text: result)
                self.reloadMessagesView()
                //self.finishSendingMessage()
                JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
                self.finishReceivingMessage(animated: true)
        }
        
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
    }
    
    // Funktion, die beim Klick auf den Anhang aufgerufen wird
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
        let alertController = UIAlertController(title: "Anhang", message: "Was möchtest du anhängen?", preferredStyle: .actionSheet)
        
        // Foto anhängen
        let cameraAction = UIAlertAction(title: "Foto", style: .default, handler: {
            action in
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                    let picker = UIImagePickerController()
                    picker.delegate = self
                    picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                    picker.allowsEditing = true;
                    self.present(picker, animated: true, completion: nil)
                } else {
                    print("Photo Library is not available")
                }
        })
        alertController.addAction(cameraAction)
        
        // Location anhängen
        let locationAction = UIAlertAction(title: "Location", style: .default, handler: {
            action in
                if self.location != nil {
                    self.sendLocation(location: self.location)
                    self.sendAddress()
                    self.locationManager.stopUpdatingLocation() // Location Update stoppen, um Akku zu sparen
                } else {
                    print ("Location Service is not available")
                }
        })
        alertController.addAction(locationAction)
        
        // Aktion beenden
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)

    }
    
    // Ausgewähltes Foto in Chat anzeigen
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        //ImageDisplay.image = image
        let photoMsg = JSQPhotoMediaItem(image: image)
        //let mediaMsg = JSQMessage(senderId: senderId, displayName: senderDisplayName, media: photoMsg)
        //We have to use a do-try-catch because our saveFile method throws.
        do {
            // want to make sure the app doesn’t crash so I’m using a guard statement. In this instance, it’s a little overkill because I know the image exists, but if you were downloading one from the internet it is a good idea to use.
            // Now we save our file using the try keyword and our saveFile(imageFile:) method.
            var fallNummerImage = String(idHelper);
            var imageFileName = fallNummerImage + String(anzahlImages);
            let imageToSave:FileSaveHelper = FileSaveHelper(fileName: imageFileName, fileExtension: .JPG, subDirectory: "Images",directory: .documentDirectory);
                   try imageToSave.saveFileImage(image: image)
                anzahlImages += 1

        }
            //If there is an error, we will print it to the console window.
        catch {
            print(error)
        }
        
        self.addMediaMessage(withId: senderId, name: senderDisplayName, media: photoMsg!)
        self.finishSendingMessage(animated: true)
        
        //Add message to let API know photo has been sent
        self.api.sendRequest(request: "PHOTOADDED") { (result) -> Void in
            self.showTypingIndicator = 	false
            self.addMessage(withId: "321", name: "Chatbot", text: result)
            self.reloadMessagesView()
            //self.finishSendingMessage()
            JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
            self.finishReceivingMessage(animated: true)
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // Location im Chat anzeigen
    func sendLocation (location: CLLocation) {
        let locationMsg = JSQLocationMediaItem(location: nil)
        locationMsg?.setLocation(location, withCompletionHandler: { 
            self.addMediaMessage(withId: self.senderId, name: self.senderDisplayName, media: locationMsg!)
            self.finishSendingMessage(animated: true)
            self.dismiss(animated: true, completion: nil)
            
            
            //Add message to let API know location has been sent
            self.api.sendRequest(request: "LOCATIONSEND") { (result) -> Void in
                self.showTypingIndicator = 	false
                self.addMessage(withId: "321", name: "Chatbot", text: result)
                self.reloadMessagesView()
                //self.finishSendingMessage()
                JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
                self.finishReceivingMessage(animated: true)
            }

        })
        
        
        
    }
    
    // Location in Adresse umwandeln
    func getAdress() {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if (error != nil) {
                print("Geocoder failed with error " + (error?.localizedDescription)!)
                return
            }
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])! as CLPlacemark
                let street = (pm.thoroughfare != nil) ? pm.thoroughfare : ""
                let number = (pm.subThoroughfare != nil) ? pm.subThoroughfare : ""
                let postalCode = (pm.postalCode != nil) ? pm.postalCode : ""
                let locality = (pm.locality != nil) ? pm.locality : ""
                self.address = street! + " " + number! + "\n" + postalCode! + " " + locality!
                allgemein.location = self.address;   // Für Speichern in json-Datei
            } else {
                print("No data received from Geocoder")
            }
        })
    }
    
    // Adresse im Chat anzeigen
    func sendAddress() {
        self.addMessage(withId: senderId, name: senderDisplayName, text: self.address)
    }
    
}

    //MARK - Setup
    extension ChatViewController {
        func addWelcomeMessage() {
            /*for i in 1...15 {
                let sender = (i%2 == 0) ? "Server" : self.senderId
                let messageContent = "Message nr. \(i)"
                let message = JSQMessage(senderId: sender, displayName: sender, text: messageContent)
                self.messages.append(message!)
            }*/
            let sender = "321"
            let chatbotName = "Chatbot"
            let messageContent = "Willkommen beim Taschenanwalt. Ich helfe dir, wenn du einen Autounfall hattest oder dein Zug verspätet ist. Schreibe mir einfach was dein Problem ist und ich führe dich Schritt für Schritt zur Lösung deines Problems."
            let message = JSQMessage(senderId: sender, displayName: chatbotName, text: messageContent)
            self.messages.append(message!)
            self.reloadMessagesView()
        }
        
        func setup() {
            self.senderId = "1234"
            self.senderDisplayName = "blub"
        }
    }
