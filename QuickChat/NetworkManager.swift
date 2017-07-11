//
//  NetworkManager.swift
//  QuickChat
//
//  Created by 손은주 on 2017. 7. 11..
//  Copyright © 2017년 Mexonis. All rights reserved.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    func downloadImage(imageURL: URL,
                       completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            if error == nil {
                completion(data!)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
}
