//
//  ManagerProtocol.swift
//  Neuy
//
//  Created by NeuyAI on 2023-06-27.
//

import Foundation

class NeuyDataManager: NSObject, ObservableObject {
    var selectedType: Int = 0 {
        didSet {
            filterResults()
        }
    }
    
    func filterResults() {
        
    }
    func downloadData() {
        
    }
    func saveData() {
        
    }
    func loadData() {
        
    }
}
