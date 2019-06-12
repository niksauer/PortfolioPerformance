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
    var classificationTypes: Set<ClassificationType> { return Set(classifications.map { $0.type }) }
    
    // MARK: - Private Properties
    private var securities: [Security] { didSet { didChange.send(self) }}
    private var accounts: [Account] { didSet { didChange.send(self) }}
    private var classifications: [Classification] { didSet { didChange.send(self) }}
    private var securityClassifications: [ClassificationAssignment<Security, Classification>] { didSet { didChange.send(self) }}
    private var accountClassifications: [ClassificationAssignment<Account, Classification>] { didSet { didChange.send(self) }}
    
    // MARK: - Initialization
    init() {
        let testData = TestData()
        
        self.securities = testData.securities
        self.accounts = testData.accounts
        self.classifications = testData.classifications
        self.securityClassifications = testData.securityClassifications
        self.accountClassifications = testData.accountClassifications
//        self.transactions = transactions
    }
    
    // MARK: - Public Methods
    func getFlatClassificationHierarchy(type: ClassificationType, includeEntries: Bool) -> [FlatHierarchyObject] {
        func getFlatHierarchy(of classification: Classification, hierarchyLevel: Int, hasParent: Bool) -> [FlatHierarchyObject] {
            var flatHierarchy = [FlatHierarchyObject]()
            
            flatHierarchy.append(FlatHierarchyObject(object: classification, hierarchyLevel: hierarchyLevel, hasParent: hasParent))
            
            if includeEntries {
                for security in getSecurities(classification: classification) {
                    flatHierarchy.append(FlatHierarchyObject(object: security, hierarchyLevel: hierarchyLevel, hasParent: true))
                }
                
                for account in getAccounts(classification: classification) {
                    flatHierarchy.append(FlatHierarchyObject(object: account, hierarchyLevel: hierarchyLevel, hasParent: true))
                }
            }
            
            for subClassification in getSubClassifications(of: classification) {
                flatHierarchy.append(contentsOf: getFlatHierarchy(of: subClassification, hierarchyLevel: hierarchyLevel + 1, hasParent: true))
            }
            
            return flatHierarchy
        }
        
        return getRootClassifications(type: type).flatMap { getFlatHierarchy(of: $0, hierarchyLevel: 0, hasParent: true) }
    }
    
    func getUnclassifiedObjects(type: ClassificationType) -> [FlatHierarchyObject] {
        return getUnclassifiedSecurities(type: type).map { FlatHierarchyObject(object: $0, hierarchyLevel: 0, hasParent: false) }
    }
    
    func moveClassifiedObject(from source: IndexSet, to destination: Int, classificationHierarchyType: ClassificationType, showsEntries: Bool) {
        let source = source.first!
        let hierarchy = getFlatClassificationHierarchy(type: classificationHierarchyType, includeEntries: showsEntries)
        
        let sourceObject = hierarchy[source]
        
        if destination == 0 {
            // make unclassified
            removeClassification(objectID: sourceObject.id, objectType: sourceObject.wrappedType, classificationType: classificationHierarchyType)
        } else {
            // find nearest parent classification
        
            let distanceToTopmostRoot = destination - 1
            let movementOffset = destination > source ? 2 : 2
            let downMovementOffset = destination > source ? 1 : 0
            let upMovementOffset = destination < source ? 1 : 0
            
            var newParentObject: FlatHierarchyObject?
    
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
            
            changeClassification(objectID: sourceObject.id, objectType: sourceObject.wrappedType, classificationType: classificationHierarchyType, newClassificationID: newClassificationID)
        }
    }
    
    func moveUnclassifiedObject(from source: IndexSet, to destination: Int) {
        source.sorted { $0 > $1 }.forEach { print("source: \($0)") }
        print("destination: \(destination)")
    }
    
    func deleteClassification(at source: IndexSet) {
        
    }
    
    // MARK: - Private Methods
    // MARK: Classification
    private func getRootClassifications(type: ClassificationType) -> [Classification] {
        return classifications.filter { $0.parentID == nil && $0.type == type }
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
    
    private func getUnclassifiedSecurities(type: ClassificationType) -> [Security] {
        return getUnclassifiedObjects(type: type.rawValue, objects: securities, assignments: securityClassifications)
    }
    
    // MARK: Account
    private func getAccounts(classification: Classification) -> [Account] {
        return getObjects(classification: classification, objects: accounts, assignments: accountClassifications)
    }
    
    private func getUnclassifiedAccounts(type: ClassificationType) -> [Account] {
        return getUnclassifiedObjects(type: type.rawValue, objects: accounts, assignments: accountClassifications)
    }
    
    // MARK: Concrete Classifiable
    private func removeClassification(objectID: UUID, objectType: String, classificationType: ClassificationType) {
        switch objectType {
        case "Account":
            self.accountClassifications = removeClassification(objectID: objectID, classificationType: classificationType.rawValue, assignments: accountClassifications)
        case "Security":
            self.securityClassifications = removeClassification(objectID: objectID, classificationType: classificationType.rawValue, assignments: securityClassifications)
        default:
            break
        }
    }
    
    private func changeClassification(objectID: UUID, objectType: String, classificationType: ClassificationType, newClassificationID: UUID) {
        switch objectType {
        case "Account":
            self.accountClassifications = changeClassification(objectID: objectID, classificationType: classificationType.rawValue, newClassificationID: newClassificationID, assignments: accountClassifications)
        case "Security":
            self.securityClassifications = changeClassification(objectID: objectID, classificationType: classificationType.rawValue, newClassificationID: newClassificationID, assignments: securityClassifications)
        default:
            break
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
