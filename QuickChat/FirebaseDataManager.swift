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
    
}
