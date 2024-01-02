//
//  NeuyServiceAPI.swift
//  NeuyDeFi
//
//  Created by NeuyAI on 2023-06-07.
//

import UIKit

enum SortOrders {
    case symbol
    case name
    case icon
    case type
    case sector
    case binance
    case coinbase
    case marketcap
    case holders
    case bscHolders
    case ftmHolders
    case polyHolders
    case avaHolders
    case nativeHolders
    case availableSupply
    case totalSupply
    case change24hrs
}

enum FilterTypes {
    case favorites
    case all
}


class NeuyCryptoManager: NeuyDataManager {
    private var neuyNetwork = NeuyNetwork()
    private var cryptoArray: [CryptoListItem] = []

    var favs = NeuyFavoritesManager()

    var filterType: FilterTypes = .all
    @Published var filterString: String = ""
    var sortOrder: SortOrders = .marketcap
    var sortAcsending: Bool = false
    var timer: Timer?
    var isDownloading: Bool = false
    @Published var imageArray: [String:UIImage] = [:]
    @Published var crypto: [CryptoListItem] = []

    override init() {
        super.init()
        loadData()
        timer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) {[weak self] timer in
            self?.downloadData()
        }
    }

    override func filterResults() {
        favs.loadData()
        crypto.removeAll()
        if filterType == .all {
            crypto = cryptoArray
        } else {
            crypto = cryptoArray.filter({ item in
                return favs.favs.contains(item.symbol ?? "")
            })
        }

        if filterString != ""  {
            crypto = crypto.filter({ item in
                if item.symbol?.lowercased().contains(filterString.lowercased()) ?? false ||
                    item.about?.lowercased().contains(filterString.lowercased()) ?? false ||
                    item.sector?.lowercased().contains(filterString.lowercased()) ?? false ||
                    item.type?.lowercased().contains(filterString.lowercased()) ?? false {
                    return true
                } else {
                    return false
                }
            })
        }

        switch sortOrder {
        case .symbol:
            crypto = crypto
                .filter({ token in

                    if let mktcap = token.marketcap, let floatMkt = Float(mktcap), let price = Float(token.getPrice().replacingOccurrences(of: "$", with: "")), price > 0.0 {
                        return floatMkt > 0.0
                    } else {
                        return false
                    }
                })
                .sorted {
                    if let first = $0.symbol, let second = $1.symbol  {
                        return first > second
                    } else {
                        return false
                    }
                }
        case .name:
            crypto = crypto
                .filter({ token in

                    if let mktcap = token.marketcap, let floatMkt = Float(mktcap), let price = Float(token.getPrice().replacingOccurrences(of: "$", with: "")), price > 0.0 {
                        return floatMkt > 0.0
                    } else {
                        return false
                    }
                })
                .sorted {
                    if let first = $0.name, let second = $1.name  {
                        return first < second
                    } else {
                        return false
                    }
                }
        case .icon:
            crypto = crypto.sorted {
                if let first = $0.icon, let second = $1.icon  {
                    return first > second
                } else {
                    return false
                }
            }
        case .type:
            crypto = crypto.sorted {
                if let first = $0.type, let second = $1.type  {
                    return first > second
                } else {
                    return false
                }
            }
        case .sector:
            crypto = crypto.sorted {
                if let first = $0.sector, let second = $1.sector  {
                    return first > second
                } else {
                    return false
                }
            }
        case .binance:
            crypto = crypto.sorted {
                if let first = Float($0.binance ?? "0.0"), let second = Float($1.binance ?? "0.0") {
                    return first > second
                } else {
                    return false
                }
            }
        case .coinbase:
            crypto = crypto.sorted {
                if let first = Float($0.coinbase ?? "0.0"), let second = Float($1.coinbase ?? "0.0") {
                    return first > second
                } else {
                    return false
                }
            }

        case .marketcap:
            crypto = crypto.sorted {
                if let first = Float($0.marketcap ?? "0.0"), let second = Float($1.marketcap ?? "0.0"), first > 0 && second > 0 {
                    if sortAcsending == false {
                        return first > second
                    } else {
                        return first < second
                    }
                } else {
                    return false
                }
            }
        case .holders:
            crypto = crypto
                .filter({ token in

                    if let mktcap = token.marketcap, let floatMkt = Float(mktcap), let price = Float(token.getPrice().replacingOccurrences(of: "$", with: "")), price > 0.0 {
                        return floatMkt > 0.0
                    } else {
                        return false
                    }
                })
                .sorted {
                    if let first = Float($0.holders ?? "0.0"), let second = Float($1.holders ?? "0.0") {
                        return first > second
                    } else {
                        return false
                    }
                }
        case .bscHolders:
            crypto = crypto.sorted {
                if let first = Float($0.bscHolders ?? "0.0"), let second = Float($1.bscHolders ?? "0.0") {
                    return first > second
                } else {
                    return false
                }
            }
        case .ftmHolders:
            crypto = crypto.sorted {
                if let first = Float($0.ftmHolders ?? "0.0"), let second = Float($1.ftmHolders ?? "0.0") {
                    return first > second
                } else {
                    return false
                }
            }
        case .polyHolders:
            crypto = crypto.sorted {
                if let first = Float($0.polyHolders ?? "0.0"), let second = Float($1.polyHolders ?? "0.0") {
                    return first > second
                } else {
                    return false
                }
            }
        case .avaHolders:
            crypto = crypto.sorted {
                if let first = Float($0.avaHolders ?? "0.0"), let second = Float($1.avaHolders ?? "0.0") {
                    return first > second
                } else {
                    return false
                }
            }
        case .nativeHolders:
            crypto = crypto.sorted {
                if let first = Float($0.nativeHolders ?? "0.0"), let second = Float($1.nativeHolders ?? "0.0") {
                    return first > second
                } else {
                    return false
                }
            }
        case .availableSupply:
            crypto = crypto.sorted {
                if let first = Float($0.availableSupply ?? "0.0"), let second = Float($1.availableSupply ?? "0.0") {
                    return first > second
                } else {
                    return false
                }
            }
        case .totalSupply:
            crypto = crypto.sorted {
                if let first = Float($0.totalSupply ?? "0.0"), let second = Float($1.totalSupply ?? "0.0") {
                    return first > second
                } else {
                    return false
                }
            }
        case .change24hrs:
            crypto = crypto
                .filter({ token in

                    if let mktcap = token.marketcap, let floatMkt = Float(mktcap), let price = Float(token.getPrice().replacingOccurrences(of: "$", with: "")), price > 0.0 {
                        return floatMkt > 0.0
                    } else {
                        return false
                    }
                })
                .sorted {
                    if let first = Float($0.change24hrs ?? "0.0"), let second = Float($1.change24hrs ?? "0.0") {
                        if sortAcsending == false {
                            return first > second
                        } else {
                            return first < second
                        }

                    } else {
                        return false
                    }
                }
        }

        crypto = Array(crypto.prefix(500))

    }

    override func downloadData() {
        if isDownloading { return }
        isDownloading = true
        neuyNetwork.networkConnection(urlString: NEUYURLS.cryptocurriencies.rawValue) { result in
            switch result {
            case .failure(let error):
                print(error)
                self.isDownloading = false
                return
            case .success(let output):
                if let arr = output["assets"] as? [[String:String]] {
                    self.cryptoArray.removeAll()
                    for item in arr {
                        let crypto = CryptoListItem()
                        crypto.setData(importData: item)
                        if let iconURL = item["icon"], self.imageArray[iconURL]?.size.width == nil, let symbol = crypto.symbol {
                            self.downloadImage(symbol: symbol, iconURL: iconURL)
                        }
                        self.cryptoArray.append(crypto)
                    }
                    self.saveData()
                    self.filterResults()
                    //self.generateHTMLCodeForBSCToken()
                }
                self.isDownloading = false
            }
        }
    }

    override func saveData() {
        do {
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let cryptoPath = documentsPath.appendingPathComponent("crypto").appendingPathExtension("json")
            let dataSourceURL = cryptoPath

            let encoder = PropertyListEncoder()
            let data = try encoder.encode(cryptoArray)
            try data.write(to: dataSourceURL)
        } catch {

        }
    }

    override func loadData() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let cryptoPath = documentsPath.appendingPathComponent("crypto").appendingPathExtension("json")
        let dataSourceURL = cryptoPath
        do {
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: dataSourceURL)
            cryptoArray = try! decoder.decode([CryptoListItem].self, from: data)
            for i in cryptoArray {
                if let iconURL = i.icon, self.imageArray[iconURL]?.size.width == nil, let symbol = i.symbol {
                    downloadImage(symbol: symbol, iconURL:iconURL)
                }
            }
            filterResults()
        } catch {
            downloadData()
        }
    }

    func downloadImage(symbol: String, iconURL:String) {

        if let image = UIImageSaving.loadData(imageName: symbol) {
            self.imageArray[iconURL] = image
        } else {
            DispatchQueue.global().async {
                if let url = URL(string: iconURL), let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.imageArray[iconURL] = UIImage(data: data)
                        if let img = self.imageArray[iconURL] {
                            UIImageSaving.saveData(image: img, imageName: symbol)
                        }
                    }
                }
            }
        }
    }

    func stringToSortOrder(sortString: String) -> SortOrders {
        switch sortString {
        case "symbol":
            return .symbol
        case "Name":
            return .name
        case "icon":
            return .icon
        case "type":
            return .type
        case "sector":
            return .sector
        case "binance":
            return .binance
        case "coinbase":
            return .coinbase
        case "MarketCap", "SmallCap":
            return .marketcap
        case "Holders":
            return .holders
        case "bscHolders":
            return .bscHolders
        case "ftmHolders":
            return .ftmHolders
        case "polyHolders":
            return .polyHolders
        case "avaHolders":
            return .avaHolders
        case "nativeHolders":
            return .nativeHolders
        case "availableSupply":
            return .availableSupply
        case "totalSupply":
            return .totalSupply
        case "Gainers", "Losers":
            return .change24hrs
        default:
            return .marketcap
        }
    }
}
