//
//  AssetStore.swift
//  Portfolio
//
//  Created by Nik Sauer on 08.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import Foundation

//class ClassifiedObjectCollection<T: Classifiable> {
//    typealias ClassifiedObject = T
//    var elements = [ClassifiedObject]()
//
//    func addElement(element: ClassifiedObject) {
//        elements.append(element)
//    }
//
//    func removeElement(element: ClassifiedObject) -> Bool {
//        guard let index = elements.firstIndex(where: { $0.id == element.id }) else {
//            return false
//        }
//
//        elements.remove(at: index)
//        return true
//    }
//}

struct AssetStore {
    
    // MARK: - Private Properties
    private var securities: [Security]
    var accounts: [Account]
    private var classifications: [Classification]
    private var transactions: [DepotTransaction]
    
    // MARK: - Initialization
    init(securities: [Security], accounts: [Account], classifications: [Classification], transactions: [DepotTransaction]) {
        self.securities = securities
        
        self.accounts = accounts
        
        self.classifications = classifications
        let stockClassification = Classification(name: "Aktien", type: .AssetAllocation, parentID: classifications[0].id)
        self.classifications.append(stockClassification)
        self.classifications.append(Classification(name: "Aktien Industrieländer", type: .AssetAllocation, parentID: stockClassification.id, associatedObjects: Set(arrayLiteral: securities[2].id)))
        self.classifications.append(Classification(name: "Aktien Schwellenländer", type: .AssetAllocation, parentID: stockClassification.id, associatedObjects: Set(arrayLiteral: securities[1].id)))
        self.classifications.append(Classification(name: "Immobilien", type: .AssetAllocation, parentID: classifications[0].id))
        
        self.transactions = transactions
    }
    
    // MARK: - Public Methods
    func getRootClassifications(for type: ClassificationType) -> [Classification] {
        return classifications.filter { $0.parentID == nil && $0.type == type }
    }
    
    func getSubClassifications(for classification: Classification) -> [Classification] {
        return classifications.filter { $0.parentID == classification.id }
    }
    
    func getSecurities(for classification: Classification) -> [Security] {
        return securities.filter { classification.associatedObjects.contains($0.id) }
    }
    
    func getAccounts(for classification: Classification) -> [Account] {
        return accounts.filter { classification.associatedObjects.contains($0.id) }
    }
    
    func getIndentLevel(for classification: Classification) -> Int {
        guard let parentID = classification.parentID, let parent = classifications.first(where: { $0.id == parentID }) else {
            return 0
        }
        
        return 1 + getIndentLevel(for: parent)
    }
}
