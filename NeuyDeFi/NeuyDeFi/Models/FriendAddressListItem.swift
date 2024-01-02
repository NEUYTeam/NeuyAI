//
//  FriendAddressListItem.swift
//  Neuy
//
//  Created by NeuyAI on 2023-07-06.
//

import UIKit

class FriendAddressListItem: NSObject, Codable, Identifiable {
    var id = UUID()
    var name: String
    var address: String

    init(friendName: String, friendAddress: String) {
        name = friendName
        address = friendAddress
    }

    static func ==(lhs: FriendAddressListItem, rhs: FriendAddressListItem) -> Bool {
        return lhs.address == rhs.address
    }
}
