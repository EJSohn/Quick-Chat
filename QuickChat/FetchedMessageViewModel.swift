//
//  FetchedMessageViewModel.swift
//  QuickChat
//
//  Created by 손은주 on 2017. 7. 10..
//  Copyright © 2017년 Mexonis. All rights reserved.
//

import Foundation

struct FetchedMessageViewModel {
    var message: Message
}

extension FetchedMessageViewModel {
    init(msg: Message) {
        self.message = msg
    }
}

struct MessageViewModel {
    var ownser: MessageOwner
    var type: MessageType
    var content: Any
    var timestamp: Int
    var isRead: Bool
    private var toID: String?
    private var fromID: String?
    
}

extension MessageViewModel {
    init(message: Message) {
        ownser = message.owner
        type = message.type
        content = message.content
        timestamp = message.timestamp
        isRead = message.isRead
    }
}
