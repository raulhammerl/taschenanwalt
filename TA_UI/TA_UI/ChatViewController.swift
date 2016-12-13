//
//  ViewController.swift
//  
//
//  Created by King Kraul on 08/12/2016.
//
//

import UIKit
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    
    
    // dark blue (red: 56/255, green: 77/255, blue: 100/255, alpha: 1.0)
    // light grey (red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
    // orange1 UIColor(red: 243/255, green: 156/255, blue: 18/255, alpha: 1.0)
    

    var messages = [JSQMessage]()
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    override func viewWillAppear(_ animated: Bool) {
       self.collectionView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //DEMO SETUP
        self.senderId = "123"
        self.senderDisplayName = "abc"
        self.setup()
        self.addDemoMessages()
        self.finishReceivingMessage()
        
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
    
    //send button handling
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let messageItem = [
            "senderId": senderId!,
            "senderName": senderDisplayName!,
            "text": text!,
            ]
        
        self.addMessage(withId: senderId, name: senderDisplayName, text: text)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
    }
    
    
    
}
    //MARK - Setup
    extension ChatViewController {
        func addDemoMessages() {
            for i in 1...15 {
                let sender = (i%2 == 0) ? "Server" : self.senderId
                let messageContent = "Message nr. \(i)"
                let message = JSQMessage(senderId: sender, displayName: sender, text: messageContent)
                self.messages.append(message!)
            }
            self.reloadMessagesView()
        }
        
        func setup() {
            self.senderId = "1234"
            self.senderDisplayName = "blub"
        }
    }
