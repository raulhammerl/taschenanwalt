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
    
<<<<<<< HEAD
    
    // dark blue (red: 56/255, green: 77/255, blue: 100/255, alpha: 1.0)
    // light grey (red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.black)
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.lightGray)
    var messages = [JSQMessage]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DEMO SETUP
       
        self.setup()
        self.addDemoMessages()
        
        //make avatars size zero
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
=======

    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.lightGray)
    var messages = [JSQMessage]()

    override func viewDidLoad() {
        super.viewDidLoad()

>>>>>>> 0fcab63bd6f3a91bd61b90eb114006fa2151508a
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

<<<<<<< HEAD
    func reloadMessagesView() {
        self.collectionView?.reloadData()
    }
    
    
    //override avatars with nil
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    
}
    //MARK - Setup
    extension ChatViewController {
        func addDemoMessages() {
            for i in 1...10 {
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
=======
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
>>>>>>> 0fcab63bd6f3a91bd61b90eb114006fa2151508a
