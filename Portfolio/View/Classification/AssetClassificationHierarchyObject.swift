//
//  AssetClassificationHierarchyObject.swift
//  Portfolio
//
//  Created by Nik Sauer on 10.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

protocol AssetClassificationHierarchyObjectModel: Identifiable where ID == UUID {
    var title: String { get }
//    var subtitle: String? { get }
//    var icon: Image { get }
    var isHierarchyEntry: Bool { get }
}

struct AssetClassificationHierarchyObject: HierarchyObjectModel {

    // MARK: - Public Properties
//    let title: String
//    let subtitle: String?
//    let icon: Image
//    let wrappedType: String
    let title: String
    let wrappedObject: Any
    
    // MARK: FlatHierarchyObjectModel
    let id: UUID
    let isHierarchyEntry: Bool
    let hierarchyLevel: Int
    let hasParent: Bool
    let disableMovement: Bool
    let disableDeletion: Bool
    
    // MARK: - Initialization
    init<T: AssetClassificationHierarchyObjectModel>(object: T, hierarchyLevel: Int, hasParent: Bool, disableMovement: Bool, disableDeletion: Bool) {
//        self.title = object.title
//        self.subtitle = object.subtitle
//        self.icon = object.icon
//        self.wrappedType = "\(type(of: object))"
        self.title = object.title
        self.wrappedObject = object
        
        self.id = object.id
        self.isHierarchyEntry = object.isHierarchyEntry
        self.hierarchyLevel = hierarchyLevel
        self.hasParent = hasParent
        self.disableMovement = disableMovement
        self.disableDeletion = disableDeletion
    }
    
}
