//
//  CryptoListItem.swift
//  NeuyDeFi
//
//  Created by NeuyAI on 2023-06-07.
//

import Foundation
import SwiftUI

class CryptoListItem: NSObject, Codable, Identifiable {
    var symbol: String?
    var name: String?
    var icon: String?
    var type: String?
    var sector: String?
    var website: String?
    var about: String?
    var binance: String?
    var coinbase: String?
    var avePrice: String?
    var kraken: String?
    var marketcap: String?
    var holders: String?
    var bscHolders: String?
    var ftmHolders: String?
    var polyHolders: String?
    var avaHolders: String?
    var arbHolders: String?
    var opHolders: String?
    var nativeHolders: String?
    var availableSupply: String?
    var totalSupply: String?
    var change24hrs: String?
    
    func setData(importData: [String:String]) {
        symbol = importData["symbol"]
        name = importData["name"]
        icon = importData["icon"]
        type = importData["type"]
        sector = importData["sector"]
        avePrice = importData["averageprice"]
        website = importData["website"]
        about = importData["description"]
        binance = importData["binance"]
        coinbase = importData["coinbase"]
        kraken = importData["kraken"]
        marketcap = importData["marketcap"]
        holders = importData["holders"]
        bscHolders = importData["bscHolders"]
        ftmHolders = importData["ftmHolders"]
        polyHolders = importData["polyHolders"]
        avaHolders = importData["avaHolders"]
        opHolders = importData["opHolders"]
        arbHolders = importData["arbHolders"]
        nativeHolders = importData["nativeHolders"]
        availableSupply = importData["availableSupply"]
        totalSupply = importData["totalSupply"]
        change24hrs = importData["change24hrs"]
    }
    
    func getPrice() -> String {
        var foundValue = false
        var price = 0.0
        if let value = Double(avePrice ?? "0.0"), value > 0.0 {
            price = value
            foundValue = true
        }
        if let value = Double(binance ?? "0.0"), value > 0.0 {
            price = value
            foundValue = true
        }
        if let value = Double(coinbase ?? "0.0"), value > 0.0 && foundValue == false {
            price = value
            foundValue = true
        }
        var decimalPlaces: Int = 10
        if price > 0.00001 {
            decimalPlaces = 8
        }
        if price > 0.001 {
            decimalPlaces = 5
        }
        if price > 1.0 {
            decimalPlaces = 3
        }
        if price > 100.0 {
            decimalPlaces = 1
        }

        price *= pow(10.0,Double(decimalPlaces))
        price = price.rounded() / pow(10.0,Double(decimalPlaces))
        return "$" + price.description
    }
    
    func get24Change() -> String {
        var price = Double(change24hrs ?? "0.0") ?? 0.0
        price *= 1000
        price = price.rounded() / 1000
        return price.description + "%"
    }
    func get24ChangeColor() -> Color {
        var price = Double(change24hrs ?? "0.0") ?? 0.0
        price *= 1000
        price = price.rounded() / 1000
        return price > 0.0 ? .green : .red
    }

    func getFormattedMarketCap() -> String {
        if let cap = Double(marketcap ?? "0.0") {
            if cap > 1000.0 {
                return ((round((cap / 1000.0) * 100.0)) / 100.0).description + "B"
            } else {
                return cap.description + "M"
            }
        } else {
            return "0.0M"
        }
    }
}
