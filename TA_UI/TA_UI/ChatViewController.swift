//
//  ViewController.swift
//  
//
//  Created by King Kraul on 08/12/2016.
//
//

import UIKit
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    // dark blue (red: 56/255, green: 77/255, blue: 100/255, alpha: 1.0)
    // light grey (red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
    // orange1 UIColor(red: 243/255, green: 156/255, blue: 18/255, alpha: 1.0)
    

    var messages = [JSQMessage]()
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    var api = APIRequest()
    
    override func viewWillAppear(_ animated: Bool) {
       self.collectionView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //DEMO SETUP
        self.senderId = "123"
        self.senderDisplayName = "abc"
        self.setup()
        self.addWelcomeMessage()
        //self.finishReceivingMessage()
        
        //make avatars size zero
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        // Do any additional setup after loading the view.
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
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            picker.allowsEditing = true;
            self.present(picker, animated: true, completion: nil)
            
        }

    }
    
    /* Ausgewähltes Foto in Chat anzeigen */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        //ImageDisplay.image = image
        let photoMsg = JSQPhotoMediaItem(image: image)
        //let mediaMsg = JSQMessage(senderId: senderId, displayName: senderDisplayName, media: photoMsg)
        self.addMediaMessage(withId: senderId, name: senderDisplayName, media: photoMsg!)
        self.finishSendingMessage(animated: true)
        self.dismiss(animated: true, completion: nil)
        
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
