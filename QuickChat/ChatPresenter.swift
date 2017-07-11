//
//  ChatPresenter.swift
//  QuickChat
//
//  Created by 손은주 on 2017. 7. 10..
//  Copyright © 2017년 Mexonis. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

// UIKit only used for UIImage

class ChatPresenter {
    
    typealias View = FetchMessages
    
    let view: View
    
    init(view: View) {
        self.view = view
    }

}

extension ChatPresenter {
    
    // Pull all messages
    func downloadAllMessages(forUserID userID: String) {
        
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
    
    // Send messages 
    func send(message: Message,
              toID: String
        ) {
        var values: [String: Any] = [:]
        
        switch message.type {
        case .location:
            values = [
                "type": "location",
                "content": message.content,
                "toID": toID,
                "timestamp": message.timestamp,
                "isRead": false
            ]
    
        case .photo:
            let imageData = UIImageJPEGRepresentation((message.content as! UIImage), 0.5)
            let child = UUID().uuidString
            
            FirebaseDataManager.shared.getFirebaseImageMetadata(
            imageData: imageData!,
            child: child) { (metadata, error) in
                if let _ = error {
                    return
                }
                
                let path = metadata?.downloadURL()?.absoluteString
                values = [
                    "type": "photo",
                    "content": path!,
                    "toID": toID,
                    "timestamp": message.timestamp,
                    "isRead": false
                    ] as [String: Any]
                
            }
        case .text:
            values = [
                "type": "text",
                "content": message.content,
                "toID": toID,
                "timestamp": message.timestamp,
                "isRead": false
            ] as [String: Any]
            
        }
        
        FirebaseDataManager.shared.uploadMessage(
            withValues: values,
            toID: toID) { (status) in
                print(status)
        }
    }
    
    func checkLocationPermission() -> Bool {
        var state = false
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            state = true
        case .authorizedAlways:
            state = true
        default: break
        }
        return state
    }
    
}
