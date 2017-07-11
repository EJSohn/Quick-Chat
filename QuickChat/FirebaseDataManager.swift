//
//  FirebaseDataManager.swift
//  QuickChat
//
//  Created by 손은주 on 2017. 7. 10..
//  Copyright © 2017년 Mexonis. All rights reserved.
//

import Foundation
import Firebase

class FirebaseDataManager {
    static let shared = FirebaseDataManager()
    
    func getFirebaseConversation(
        forUserID: String,
        completion: @escaping ([String: Any]?, String?) -> Void) {
        
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(nil, nil)
            return
        }

        Database.database().reference().child("users").child(currentUserID).child("conversations").child(forUserID).observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                
                let data = snapshot.value as! [String: String]
                let location = data["location"]!
                    
                Database.database().reference().child("conversations").child(location).observe(.childAdded, with: { (snap) in
                    if snap.exists() {
                        let receivedMessage = snap.value as! [String: Any]
                        
                        completion(receivedMessage, currentUserID)
                    } else {
                        completion(nil, nil)
                    }
                })
            } else {
                completion(nil , nil)
            }
        })
    }
    
    func getFirebaseImageMetadata(
        imageData: Data,
        child: String,
        completion: @escaping (StorageMetadata?, Error?) -> Void) {
        
        Storage.storage().reference().child("messagePics").child(child).putData(imageData, metadata: nil) { (metadata, error) in
            completion(metadata, error)
        }
    }
    
    func uploadMessage(
        withValues: [String: Any],
        toID: String,
        completion: @escaping (Bool) -> Void) {
        
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        
        Database.database().reference().child("users").child(currentUserID).child("conversations").child(toID).observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                var values = withValues
                values["fromID"] = currentUserID
                let data = snapshot.value as! [String: String]
                let location = data["location"]!
                
                Database.database().reference().child("conversations").child(location).childByAutoId().setValue(values){ (error, _) in
                    if error == nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        })
    }
    
    
}
