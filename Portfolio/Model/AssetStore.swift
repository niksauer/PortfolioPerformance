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

struct AssetClassificationHierarchyOptions {
    let includeEntries: Bool
    let includeUnclassified: Bool
    let includeEmptyClassifications: Bool
    
    var disableClassificationMovement: Bool = true
    var disableAssetMovement: Bool = false
    
    var disableClassificationDeletion: Bool = true
    var disableAssetDeletion: Bool = true
}

class AssetStore: BindableObject {

    // MARK: - Singleton
    static let shared = AssetStore()
    
    // MARK: - Public Properties
    let didChange = PassthroughSubject<AssetStore, Never>()
    var classificationTypes: [AssetClassificationType] { return Set(classifications.map { $0.type }).sorted { $0.rawValue < $1.rawValue } }
    
    // MARK: - Private Properties
    private(set) var securities: [Security] { didSet { didChange.send(self) } }
    private(set) var accounts: [Account] { didSet { didChange.send(self) } }
    private var classifications: [Classification] { didSet { didChange.send(self) } }
    private var securityClassifications: [ClassificationAssignment<Security, Classification>] { didSet { didChange.send(self) } }
    private var accountClassifications: [ClassificationAssignment<Account, Classification>] { didSet { didChange.send(self) } }
    
    // MARK: - Initialization
    private init() {
        let testData = TestData()
        
        self.securities = testData.securities
        self.accounts = testData.accounts
        self.classifications = testData.classifications
        self.securityClassifications = testData.securityClassifications
        self.accountClassifications = testData.accountClassifications
//        self.transactions = transactions
    }
    
    // MARK: - Public Methods
    func getRootClassifications(type: AssetClassificationType, options: AssetClassificationHierarchyOptions) -> [Classification] {
        let rootClassifications = getRootClassifications(type: type, includeUnclassified: options.includeUnclassified)
        
        if !options.includeEmptyClassifications {
            return rootClassifications.filter { getFlatClassificationHierarchy(type: type, classification: $0, options: options).count > 0 }
        }
        
        return rootClassifications
    }
    
    func getFlatClassificationHierarchy(type: AssetClassificationType, options: AssetClassificationHierarchyOptions) -> [AssetClassificationHierarchyObject] {
        func getAllAssets(of classification: Classification, hierarchyLevel: Int, hasParent: Bool) -> [AssetClassificationHierarchyObject] {
            var assets = [AssetClassificationHierarchyObject]()
            
            assets.append(contentsOf: getSecurities(classification: classification).map { AssetClassificationHierarchyObject(object: $0, hierarchyLevel: hierarchyLevel, hasParent: hasParent, disableMovement: options.disableAssetMovement, disableDeletion: options.disableAssetDeletion) })
            assets.append(contentsOf: getAccounts(classification: classification).map { AssetClassificationHierarchyObject(object: $0, hierarchyLevel: hierarchyLevel, hasParent: hasParent, disableMovement: options.disableAssetMovement, disableDeletion: options.disableAssetDeletion) })
            
            return assets
        }
        
        func getFlatHierarchy(of classification: Classification, hierarchyLevel: Int, hasParent: Bool) -> [AssetClassificationHierarchyObject] {
            var flatHierarchy = [AssetClassificationHierarchyObject]()
            
            flatHierarchy.append(AssetClassificationHierarchyObject(object: classification, hierarchyLevel: hierarchyLevel, hasParent: hasParent, disableMovement: options.disableClassificationMovement, disableDeletion: options.disableClassificationDeletion))
            
            if options.includeEntries {
                flatHierarchy.append(contentsOf: getAllAssets(of: classification, hierarchyLevel: hierarchyLevel, hasParent: hasParent))
            }
            
            for subClassification in getSubClassifications(of: classification) {
                flatHierarchy.append(contentsOf: getFlatHierarchy(of: subClassification, hierarchyLevel: hierarchyLevel + 1, hasParent: true))
            }
            
            return flatHierarchy
        }
        
        return getRootClassifications(type: type, includeUnclassified: options.includeUnclassified).flatMap { getFlatHierarchy(of: $0, hierarchyLevel: 0, hasParent: true) }
    }
    
    func getFlatClassificationHierarchy(type: AssetClassificationType, classification: Classification, options: AssetClassificationHierarchyOptions) -> [AssetClassificationHierarchyObject] {
        func getAllSubclassifications(of classification: Classification) -> [Classification] {
            var subclassifications = [Classification]()
            
            let directSubclassifications = getSubClassifications(of: classification)
            subclassifications.append(contentsOf: directSubclassifications)
            
            for directSubclassification in directSubclassifications {
                subclassifications.append(contentsOf: getAllSubclassifications(of: directSubclassification))
            }
            
            return subclassifications
        }
    
        func getAllAssets(of classification: Classification, hierarchyLevel: Int, hasParent: Bool) -> [AssetClassificationHierarchyObject] {
            var assets = [AssetClassificationHierarchyObject]()
            
            assets.append(contentsOf: getSecurities(classification: classification).map { AssetClassificationHierarchyObject(object: $0, hierarchyLevel: hierarchyLevel, hasParent: hasParent, disableMovement: options.disableAssetMovement, disableDeletion: options.disableAssetDeletion) })
            assets.append(contentsOf: getAccounts(classification: classification).map { AssetClassificationHierarchyObject(object: $0, hierarchyLevel: hierarchyLevel, hasParent: hasParent, disableMovement: options.disableAssetMovement, disableDeletion: options.disableAssetDeletion) })
            
            return assets
        }
        
        func getClassificationHierarchy(of rootClassification: Classification, options: AssetClassificationHierarchyOptions) -> [AssetClassificationHierarchyObject] {
            var hierarchyObjects = [AssetClassificationHierarchyObject]()
        
            var assets = [AssetClassificationHierarchyObject]()
            assets.append(contentsOf: getAllAssets(of: rootClassification, hierarchyLevel: 0, hasParent: true))
            
            let subclassifications = getAllSubclassifications(of: rootClassification)
            assets.append(contentsOf: subclassifications.flatMap { getAllAssets(of: $0, hierarchyLevel: 0, hasParent: true) })
            
            if options.includeEmptyClassifications || (!options.includeEmptyClassifications && assets.count > 0) {
//                hierarchyObjects.append(AssetClassificationHierarchyObject(object: rootClassification, hierarchyLevel: 0, hasParent: false, disableMovement: options.disableClassificationMovement, disableDeletion: options.disableClassificationDeletion))
                hierarchyObjects.append(contentsOf: assets)
            }
            
            return hierarchyObjects
        }
    
        return getClassificationHierarchy(of: classification, options: options)
//        return getRootClassifications(type: type, includeUnclassified: options.includeUnclassified).flatMap { getClassificationHierarchy(of: $0, options: options) }
    }
    
    func moveClassifiedObject(from source: IndexSet, to destination: Int, classificationType: AssetClassificationType, hierarchyOptions: AssetClassificationHierarchyOptions) {
        let source = source.first!
        let hierarchy = getFlatClassificationHierarchy(type: classificationType, options: hierarchyOptions)
        
        let sourceObject = hierarchy[source]
        
        if destination == 0 {
            // make unclassified
            removeClassification(object: sourceObject, classificationType: classificationType)
        } else {
            // find nearest parent classification
        
            let distanceToTopmostRoot = destination - 1
            let movementOffset = destination > source ? 2 : 2
            let downMovementOffset = destination > source ? 1 : 0
            let upMovementOffset = destination < source ? 1 : 0
            
            var newParentObject: AssetClassificationHierarchyObject?
    
            for index in 1...distanceToTopmostRoot+movementOffset-upMovementOffset {
                let searchIndex = destination+downMovementOffset - index
                
                if !hierarchy[searchIndex].isHierarchyEntry {
                    newParentObject = hierarchy[searchIndex]
                    break
                }
            }
            
            guard let newClassificationID = newParentObject?.id else {
                return
            }
            
            changeClassification(object: sourceObject, classificationType: classificationType, newClassificationID: newClassificationID)
        }
    }
    
//    func moveUnclassifiedObject(from source: IndexSet, to destination: Int) {
//        source.sorted { $0 > $1 }.forEach { print("source: \($0)") }
//        print("destination: \(destination)")
//    }
    
//    func deleteClassification(at source: IndexSet) {
//
//    }
    
//    func getSecurities() -> [Security] {
//        return secu
//    }
    
    // MARK: - Private Methods
    // MARK: Classification
    private func getRootClassifications(type: AssetClassificationType, includeUnclassified: Bool) -> [Classification] {
        let rootClassifications = classifications.filter { $0.parentID == nil && $0.type == type }
        
        if !includeUnclassified {
            return rootClassifications.filter { $0.name != "Ohne Klassifizierung" }
        }
        
        return rootClassifications
    }
    
    private func getSubClassifications(of classification: Classification) -> [Classification] {
        return classifications.filter { $0.parentID == classification.id }
    }
    
    private func getHierarchyLevel(of classification: Classification) -> Int {
        guard let parentID = classification.parentID, let parent = classifications.first(where: { $0.id == parentID }) else {
            return 0
        }
        
        return 1 + getHierarchyLevel(of: parent)
    }

    // MARK: Security
    private func getSecurities(classification: Classification) -> [Security] {
        return getObjects(classification: classification, objects: securities, assignments: securityClassifications)
    }
    
    private func getUnclassifiedSecurities(type: AssetClassificationType) -> [Security] {
        return getUnclassifiedObjects(type: type.rawValue, objects: securities, assignments: securityClassifications)
    }
    
    // MARK: Account
    private func getAccounts(classification: Classification) -> [Account] {
        return getObjects(classification: classification, objects: accounts, assignments: accountClassifications)
    }
    
    private func getUnclassifiedAccounts(type: AssetClassificationType) -> [Account] {
        return getUnclassifiedObjects(type: type.rawValue, objects: accounts, assignments: accountClassifications)
    }
    
    // MARK: Concrete Classifiable
    private func removeClassification(object: AssetClassificationHierarchyObject, classificationType: AssetClassificationType) {
        switch object.wrappedObject {
        case let account as Account:
            self.accountClassifications = removeClassification(objectID: account.id, classificationType: classificationType.rawValue, assignments: accountClassifications)
        case let security as Security:
            self.securityClassifications = removeClassification(objectID: security.id, classificationType: classificationType.rawValue, assignments: securityClassifications)
        default:
            fatalError()
        }
    }
    
    private func changeClassification(object: AssetClassificationHierarchyObject, classificationType: AssetClassificationType, newClassificationID: UUID) {
        switch object.wrappedObject {
        case _ as Account:
            self.accountClassifications = changeClassification(objectID: object.id, classificationType: classificationType.rawValue, newClassificationID: newClassificationID, assignments: accountClassifications)
        case _ as Security:
            self.securityClassifications = changeClassification(objectID: object.id, classificationType: classificationType.rawValue, newClassificationID: newClassificationID, assignments: securityClassifications)
        default:
            fatalError()
        }
    }

    // MARK: Generic Classifiable
    private func getObjects<T: Classifiable, S: ClassificationOption>(classification: S, objects: [T], assignments: [ClassificationAssignment<T, S>]) -> [T] {
        let classifiedObjectIDs = assignments.filter { $0.classificationID == classification.id }.map { $0.objectID }
        return classifiedObjectIDs.compactMap { objectID in objects.first { $0.id == objectID }}
    }
    
    private func getUnclassifiedObjects<T: Classifiable, S: ClassificationOption>(type: String, objects: [T], assignments: [ClassificationAssignment<T, S>]) -> [T] {
        let classifiedObjectIDs = assignments.filter { $0.type == type }.map { $0.objectID }
        return objects.filter { !classifiedObjectIDs.contains($0.id) }
    }
    
    private func removeClassification<T: Classifiable, S: ClassificationOption>(objectID: T.ID, classificationType: String, assignments: [ClassificationAssignment<T, S>]) -> [ClassificationAssignment<T, S>] {
        guard let index = assignments.firstIndex(where: { $0.type == classificationType && $0.objectID == objectID }) else {
            return assignments
        }
        
        var assignments = assignments
        assignments.remove(at: index)
        
        return assignments
    }
    
    private func changeClassification<T: Classifiable, S: ClassificationOption>(objectID: T.ID, classificationType: String, newClassificationID: S.ID, assignments: [ClassificationAssignment<T, S>]) -> [ClassificationAssignment<T, S>] {
        guard let index = assignments.firstIndex(where: { $0.type == classificationType && $0.objectID == objectID }) else {
            return assignments
        }
        
        var assignments = assignments
        var assignment = assignments[index]
        assignment.classificationID = newClassificationID
        assignments[index] = assignment
    
        return assignments
    }
    
}
