//
//  NeuyFriendAddressManager.swift
//  Neuy
//
//  Created by NeuyAI on 2023-07-06.
//

import UIKit
import SwiftUI

class NeuyFriendAddressManager: NSObject, ObservableObject {
    
    @Published var friends:[FriendAddressListItem] = []
    
    override init() {
        super.init()
        loadData()
        
    }
    
    func addFriend(address: String) {
        if address == ""  || address.replacingOccurrences(of: " ", with: "") == ""  { return }
        let addressItem = FriendAddressListItem.init(friendName: "", friendAddress: address)
        for friend in friends {
            if friend.address == addressItem.address {
                return
            }
        }
        friends.append(addressItem)
        saveData()
    }
//
//    func removeFavorite(symbol: String) {
//        favs = favs.filter({ item in
//            return friends == item ? false : true
//        })
//        saveData()
//    }
    
    func saveData() {
        do {
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let cryptoPath = documentsPath.appendingPathComponent("addresses").appendingPathExtension("json")
            let dataSourceURL = cryptoPath
            
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(friends)
            try data.write(to: dataSourceURL)
        } catch {

        }
    }
    
    func loadData() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let cryptoPath = documentsPath.appendingPathComponent("addresses").appendingPathExtension("json")
        let dataSourceURL = cryptoPath
        do {
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: dataSourceURL)
            friends = try! decoder.decode([FriendAddressListItem].self, from: data)
        } catch {
            
        }
    }

}
