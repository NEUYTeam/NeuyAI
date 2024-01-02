//
//  NeuyTokenManager.swift
//  Neuy
//
//  Created by NeuyAI on 2023-06-20.
//

import UIKit

enum GraphType: String {
    case m5 = ""
    case hr1 = "1h"
    case d60 = "60d"
    case d120 = "120d"
    case hr1m5 = "5m1h"
}

class NeuyCryptoDetailsManager: NSObject, ObservableObject {

    private var neuyNetwork = NeuyNetwork()
    var symbol: String
    var name: String?
    var icon: String?
    var type: String?
    var sector: String?
    var website: String?
    var holders: String?
    var bscHolders: String?
    var ftmHolders: String?
    var polyHolders: String?
    var avaHolders: String?
    var nativeHolders: String?
    var opHolders: String?
    var arbHolders: String?
    var availableSupply: String?
    var totalSupply: String?
    var change24hrs: String?
    var marketcap: String?
    var averageprice: String?
    var about: String? //description
    var binance: String?
    var coinbase: String?
    var kraken: String?
    var contract: String?
    @Published var graph: [NeuyCryptoDetailsGraphItem]?
    @Published var price: [Double] = []
    @Published var mrank: [Double] = []
    @Published var srank: [Double] = []
    @Published var volume: [Double] = []
    @Published var holding: [Double] = []
    @Published var imageArray: [String:UIImage] = [:]
    @Published var priceChange: String = "0.0"
    
    var graphType: GraphType = .m5

    var timer: Timer?
    var isDownloading: Bool = false
    
    init(newSymbol: String) {
        self.symbol = newSymbol
        super.init()
        timer = Timer.scheduledTimer(withTimeInterval: 50.0, repeats: true) {[weak self] timer in
            self?.downloadData()
        }
    }

    deinit {
        timer?.invalidate()
    }
    
    func downloadData() {
        if isDownloading { return }
        neuyNetwork.networkConnection(urlString: NEUYURLS.crypto.rawValue + "?s=" + symbol + "&d=" + graphType.rawValue) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                self?.isDownloading = false
                return
            case .success(let output):
                self?.isDownloading = false
                self?.setData(importData: output)
            }
        }
    }

    func setData(importData: [String:Any]) {
        name = importData["name"] as? String
        icon = importData["icon"] as? String
        type = importData["type"] as? String
        sector = importData["sector"] as? String
        website = importData["website"] as? String
        holders = importData["holders"] as? String
        bscHolders = importData["bscHolders"] as? String
        ftmHolders = importData["ftmHolders"] as? String
        polyHolders = importData["polyHolders"] as? String
        avaHolders = importData["avaHolders"] as? String
        nativeHolders = importData["nativeHolders"] as? String
        arbHolders = importData["avaHolders"] as? String
        opHolders = importData["opHolders"] as? String
        availableSupply = importData["availableSupply"] as? String
        totalSupply = importData["totalSupply"] as? String
        change24hrs = importData["change24hrs"] as? String
        marketcap = importData["marketcap"] as? String
        averageprice = importData["averageprice"] as? String
        about = importData["description"] as? String
        binance = importData["binance"] as? String
        coinbase = importData["coinbaseprice"] as? String
        kraken = importData["krakenprice"] as? String
        contract = importData["contract"] as? String
        
        if let items = importData["graph"] as? [Any] {
            self.graph = []
            for item in items {
                if let itm = item as? [String:Double] {
                    let gra = NeuyCryptoDetailsGraphItem()
                    gra.setData(importData: itm)
                    self.graph?.append(gra)
                }
            }
        }
    
        if let gl = graph {
            self.price.removeAll()
            self.holding.removeAll()
            self.mrank.removeAll()
            self.srank.removeAll()
            self.volume.removeAll()
            for item in gl {
                if let value = item.price {
                    self.price.append(value)
                }
                if let value = item.holders {
                    self.holding.append(value)
                }
                if let value = item.mrank {
                    self.mrank.append(value)
                }
                if let value = item.srank {
                    self.srank.append(value)
                }
                if let value = item.volume {
                    self.volume.append(value)
                }
            }
            getPriceChange()
        }
    }
    func downloadImage(iconURL:String) {
        if let image = UIImageSaving.loadData(imageName: iconURL.hashValue.description) {
            self.imageArray[iconURL] = image
        } else {
            DispatchQueue.global().async {
                if let url = URL(string: iconURL), let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.imageArray[iconURL] = UIImage(data: data)
                        if let img = self.imageArray[iconURL] {
                            UIImageSaving.saveData(image: img, imageName: iconURL.hashValue.description)
                        }
                    }
                }
            }
        }
    }
    
    func getPriceChange()  {
        if let first = price.first, let last = price.last, first > 0 {
            priceChange = (((last - first) / first) * 100.0).description
        } else {
            priceChange = "0.0"
        }
    }

    func getHoldersChange() -> String {
        if let first = holding.first, let last = holding.last, first > 0 {
            let output = (((last - first) / first) * 100.0)
            return  ((round(output * 10000.0)) / 10000.0).description + "%"
        } else {
            return "0.0%"
        }
    }

    var getLow: String {
        get {
            if let min = price.min() {
                return min.description
            }
            return "0.0"
        }
    }
    var getHigh: String {
        get {
            if let max = price.max() {
                return max.description
            }
            return "0.0"
        }
    }

    func getWebsite() -> String {
        if let web = website {
            if web.hasPrefix("http:") {
                return web.replacingOccurrences(of: "http:", with: "https:")
            } else if web.hasPrefix("https:") {
                return web
            } else {
                return "https://" + web
            }
        } else {
            return ""
        }
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

    func getVolumeInDollars() -> String {
        guard let last = volume.last, let ave = Double(averageprice ?? "0") else {
            return "$0.0"
        }
        var cap = Double(last) * Double(ave)
        var suf = ""
        if cap > 1000000000 {
            cap /= 1000000000.0
            suf = "B"
        } else if cap > 1000000 {
            cap /= 1000000.0
            suf = "M"
        }

        cap = (cap * 1000.0).rounded() / 1000.0

        return "$" + cap.description + suf

    }
}
