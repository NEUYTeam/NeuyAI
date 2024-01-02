//
//  LlamaListItem.swift
//  Neuy
//
//  Created by NeuyAI on 2023-10-16.
//

import UIKit
import SwiftUI

class LiquidityPoolListItem: NSObject, Codable, Identifiable {
    var id = UUID()
    var chain: String?
    var project: String?
    var symbol: String?
    var tvlUsd: Double?
    var apyBase: Int?
    var apyReward:String?
    var apy: Double?
    var rewardTokens: String?
    var pool: String?
    var apyPct1D: Double?
    var apyPct7D: Double?
    var apyPct30D: Double?
    var stablecoin: Bool?
    var ilRisk: String?
    var exposure: String?
    var poolMeta: String?
    var mu: Double?
    var sigma: Double?
    var count: Double?
    var outlier: Bool?
    var underlyingTokens: [String]?

    func setData(importData: [String:Any]) {

        chain = importData["chain"] as? String
        project = importData["project"] as? String
        symbol = importData["symbol"] as? String
        tvlUsd = importData["tvlUsd"] as? Double
        apyBase = importData["symbol"] as? Int
        apyReward = importData["apyReward"] as? String
        apy = importData["apy"] as? Double
        rewardTokens = importData["rewardTokens"] as? String
        pool = importData["pool"] as? String
        apyPct1D = importData["apyPct1D"] as? Double
        apyPct7D = importData["apyPct7D"] as? Double
        apyPct30D = importData["apyPct30D"] as? Double
        stablecoin = importData["stablecoin"] as? Bool
        ilRisk = importData["ilRisk"] as? String
        exposure = importData["exposure"] as? String
        poolMeta = importData["poolMeta"] as? String
        mu = importData["mu"] as? Double
        sigma = importData["sigma"] as? Double
        count = importData["count"] as? Double
        outlier = importData["outlier"] as? Bool
        underlyingTokens = importData["underlyingTokens"] as? [String]
    }

    func getFormattedTVLUSDC() -> String {
        if let cap = tvlUsd  {
            if cap > 1000000000.0 {
                return ((round((cap / 1000000000.0) * 1000.0)) / 1000.0).description + "B"
            } else {
                return ((round((cap / 1000000.0) * 1000.0)) / 1000.0).description + "M"
            }
        } else {
            return "0.0M"
        }
    }

    func get24ChangeColor() -> Color {
        var price = apyPct1D ?? 0.0
        price *= 1000
        price = price.rounded() / 1000
        return price > 0.0 ? .green : .red
    }

    

    
}
