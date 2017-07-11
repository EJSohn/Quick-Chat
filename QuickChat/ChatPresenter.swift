//
//  ChatPresenter.swift
//  QuickChat
//
//  Created by 손은주 on 2017. 7. 10..
//  Copyright © 2017년 Mexonis. All rights reserved.
//

import Foundation

class ChatPresenter {
    
    typealias View = FetchMessages
    
    let view: View
    
    init(view: View) {
        self.view = view
    }

}

extension ChatPresenter {
    
    func downloadAllMessages(
        forUserID userID: String) {
        
        FirebaseDataManager.shared.getFirebaseConversation(forUserID: userID) { (receivedMessage, currentUserID) in
            guard let receivedMessage = receivedMessage else {
                return
            }
            
            let messageType = receivedMessage["type"] as! String
            let content = receivedMessage["content"] as! String
            let fromID = receivedMessage["fromID"] as! String
            let timestamp = receivedMessage["timestamp"] as! Int
            
            var type = MessageType.text
            switch messageType {
                case "photo":
                    type = .photo
                case "location":
                    type = .location
            default: break
            }
            
            if fromID == currentUserID {
                let message = Message.init(type: type, content: content, owner: .receiver, timestamp: timestamp, isRead: true)
                let model = FetchedMessageViewModel(message: message)
                self.view.fetchMessages(messageModel: model)
                
            } else {
                let message = Message.init(type: type, content: content, owner: .sender, timestamp: timestamp, isRead: true)
                let model = FetchedMessageViewModel(message: message)
                self.view.fetchMessages(messageModel: model)
            }
            
        }
    }
    
}
