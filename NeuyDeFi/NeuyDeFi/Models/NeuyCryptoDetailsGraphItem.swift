//
//  NeuyCryptoDetailsGraphItem.swift
//  Neuy
//
//  Created by NeuyAI on 2023-06-20.
//

import UIKit

class NeuyCryptoDetailsGraphItem: NSObject, Codable, Identifiable {
    
    var price: Double?
    var srank: Double?
    var mrank: Double?
    var volume: Double?
    var holders: Double?
    
    func setData(importData: [String:Double]) {
        price = importData["price"]
        srank = importData["srank"]
        mrank = importData["mrank"]
        volume = importData["volume"]
        holders = importData["holders"]
    }
}
