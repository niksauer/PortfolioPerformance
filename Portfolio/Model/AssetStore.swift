//
//  AssetStore.swift
//  Portfolio
//
//  Created by Nik Sauer on 08.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class AssetStore: BindableObject {
    
    // MARK: - Public Properties
    let didChange = PassthroughSubject<AssetStore, Never>()
    
    // MARK: - Private Properties
    private var securities: [Security] { didSet { didChange.send(self) }}
    private var accounts: [Account]
    private var classifications: [Classification]
    private var transactions: [DepotTransaction]
    
    // MARK: - Initialization
    init(securities: [Security], accounts: [Account], classifications: [Classification], transactions: [DepotTransaction]) {
        self.securities = securities
        self.accounts = accounts
        self.classifications = classifications
        self.transactions = transactions
        
        // level 0
        let riskfullClassification = classifications[0]
//        let risklessClassification = classifications[1]
        
        // level 1
            // riskfull
        let stockClassification = Classification(name: "Aktien", type: .AssetAllocation, parentID: riskfullClassification.id)
        self.classifications.append(stockClassification)
        
        self.classifications.append(Classification(name: "Immobilien", type: .AssetAllocation, parentID: riskfullClassification.id))
        self.classifications.append(Classification(name: "Rohstoffe", type: .AssetAllocation, parentID: riskfullClassification.id))
        
            // riskless
//        self.classifications.append(Classification(name: "Bankguthaben", type: .AssetAllocation, parentID: risklessClassification.id))
        
        // level 2
        self.classifications.append(Classification(name: "Aktien Industrieländer", type: .AssetAllocation, parentID: stockClassification.id, associatedObjects: Set(arrayLiteral: securities[2].id)))
        self.classifications.append(Classification(name: "Aktien Schwellenländer", type: .AssetAllocation, parentID: stockClassification.id, associatedObjects: Set(arrayLiteral: securities[1].id)))
    }
    
    // MARK: - Public Methods
    // MARK: Classification
    func getRootClassifications(type: ClassificationType) -> [Classification] {
        return classifications.filter { $0.parentID == nil && $0.type == type }
    }
    
    func getSubClassifications(of classification: Classification) -> [Classification] {
        return classifications.filter { $0.parentID == classification.id }
    }
    
    func getClassification(objectID: UUID, type: ClassificationType) -> Classification? {
        return classifications.first { $0.type == type && $0.associatedObjects.contains(objectID) }
    }
    
    func getHierarchyLevel(of classification: Classification) -> Int {
        guard let parentID = classification.parentID, let parent = classifications.first(where: { $0.id == parentID }) else {
            return 0
        }
        
        return 1 + getHierarchyLevel(of: parent)
    }
    
    func deleteClassification(at source: IndexSet) {
        
    }
    
    func moveClassification(from source: IndexSet, to destination: Int) {
//        source.sorted { $0 > $1 }.forEach { print("source: \($0)") }
//        print("destination: \(destination)")
    }
    
    // MARK: Security
    func getSecurities(classification: Classification) -> [Security] {
        return securities.filter { classification.associatedObjects.contains($0.id) }
    }
    
    func getUnclassifiedSecurities(type: ClassificationType) -> [Security] {
        return securities.filter { !getClassifiedObjects(type: type).contains($0.id) }
    }
    
    func moveClassifiedSecurity(from source: IndexSet, to destination: Int) {
        
    }
    
    func moveUnclassifiedSecurity(from source: IndexSet, to destination: Int) {
        
    }
    
    // MARK: Account
    func getAccounts(classification: Classification) -> [Account] {
        return accounts.filter { classification.associatedObjects.contains($0.id) }
    }
    
    func getUnclassifiedAccounts(type: ClassificationType) -> [Account] {
        return accounts.filter { !getClassifiedObjects(type: type).contains($0.id) }
    }
    
    func moveClassifiedAccount(from source: IndexSet, to destination: Int) {
        
    }
    
    func moveUnclassifiedAccount(from source: IndexSet, to destination: Int) {
        
    }
    
    // MARK: - Private Methods
    private func getClassifiedObjects(type: ClassificationType) -> [UUID] {
        let classifications = self.classifications.filter { $0.type == type }
        
        return classifications.flatMap { $0.associatedObjects }
    }
    
    private func getFlatClassificationHierarchy(type: ClassificationType, includeEntries: Bool) -> [String] {
        func getFlatHierarchy(of classification: Classification) -> [String] {
            var flatHierarchy = [String]()
            
            flatHierarchy.append(classification.name)
            
            if includeEntries {
                for security in getSecurities(classification: classification) {
                    flatHierarchy.append(security.name)
                }
                
                for account in getAccounts(classification: classification) {
                    flatHierarchy.append(account.name)
                }
            }
            
            for subClassification in getSubClassifications(of: classification) {
                flatHierarchy.append(contentsOf: getFlatHierarchy(of: subClassification))
            }
            
            return flatHierarchy
        }
        
        return getRootClassifications(type: type).flatMap { getFlatHierarchy(of: $0) }
    }
    
}
