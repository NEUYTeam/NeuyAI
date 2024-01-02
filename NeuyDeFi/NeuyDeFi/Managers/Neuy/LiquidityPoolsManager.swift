//
//  DefillamaPoolsManager.swift
//  Neuy
//
//  Created by NeuyAI on 2023-10-16.
//

import UIKit

class LiquidityPoolsManager: NeuyDataManager {
    private var neuyNetwork = NeuyNetwork()
    private var poolsArray: [LiquidityPoolListItem] = []
    @Published var pools: [LiquidityPoolListItem] = []
    var projectList: [String] = []

    var isDownloading: Bool = false
    @Published var filterString: String = ""

    override init() {
        super.init()
        loadData()
        downloadData()
    }

    override func filterResults() {

        pools = poolsArray.sorted(by: {
            Double($0.tvlUsd ?? 0.0) >= Double($1.tvlUsd ?? 0.0)
        }).filter({ item in
            if (item.chain == "Ethereum" || item.chain == "Polygon" || item.chain == "Binance") && item.tvlUsd != nil {
                return true
            } else {
                return false
            }
        })

        retrieveProjectList()

        pools = Array(pools.filter({ item in
            if filterString != "" {
                guard let pro = item.project?.lowercased(), let sym = item.symbol?.lowercased() else {
                    return false
                }
                if pro.contains(filterString.lowercased()) || sym.contains(filterString.lowercased())  {
                    return true
                } else {
                    return false
                }
            } else {
                return true
            }
        }).prefix(1000))


    }

    private func retrieveProjectList() {
        projectList = Array(Set<String>(pools.filter({$0.project != nil}).map({ $0.project! }))).sorted()
        projectList.insert("All", at: 0)
    }

    override func downloadData() {
        if isDownloading { return }
        isDownloading = true
        if filterString == "All" {
            filterString = ""
        }
        neuyNetwork.networkConnection(urlString: NEUYURLS.pools.rawValue) { result in
            self.poolsArray.removeAll()
            switch result {
            case .failure(let error):
                print(error)
                self.isDownloading = false
                return
            case .success(let output):
                if let arr = output["data"] as? [[String:Any]] {
                    for item in arr {
                        let pool = LiquidityPoolListItem()
                        pool.setData(importData: item)
                        self.poolsArray.append(pool)
                    }
                }
                self.saveData()
                self.filterResults()

                self.isDownloading = false
            }
        }
    }

    override func saveData() {
        do {
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let cryptoPath = documentsPath.appendingPathComponent("Llama").appendingPathExtension("json")
            let dataSourceURL = cryptoPath

            let encoder = PropertyListEncoder()
            let data = try encoder.encode(poolsArray)
            try data.write(to: dataSourceURL)
        } catch {

        }
    }

    override func loadData() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let cryptoPath = documentsPath.appendingPathComponent("Llama").appendingPathExtension("json")
        let dataSourceURL = cryptoPath
        do {
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: dataSourceURL)
            poolsArray = try! decoder.decode([LiquidityPoolListItem].self, from: data)
            filterResults()
        } catch {
            downloadData()
        }
    }
}
