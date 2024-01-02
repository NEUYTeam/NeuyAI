//
//  NeuyFavoritesManager.swift
//  NeuyDeFi
//
//  Created by NeuyAI on 2023-06-15.
//

import UIKit

class NeuyFavoritesManager: NSObject, ObservableObject {
    
    @Published var favs:[String] = []
    
    override init() {
        super.init()
        loadData()
        
    }
    
    func addFavorite(symbol: String) {
        favs.append(symbol)
        saveData()
    }
    
    func removeFavorite(symbol: String) {
        favs = favs.filter({ item in
            return symbol == item ? false : true
        })
        saveData()
    }
    
    func saveData() {
        do {
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let cryptoPath = documentsPath.appendingPathComponent("favs").appendingPathExtension("json")
            let dataSourceURL = cryptoPath
            
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(favs)
            try data.write(to: dataSourceURL)
        } catch {

        }
    }
    
    func loadData() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let cryptoPath = documentsPath.appendingPathComponent("favs").appendingPathExtension("json")
        let dataSourceURL = cryptoPath
        do {
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: dataSourceURL)
            favs = try! decoder.decode([String].self, from: data)
        } catch {
            
        }
    }

}
