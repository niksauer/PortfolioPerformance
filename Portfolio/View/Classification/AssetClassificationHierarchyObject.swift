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
    var subtitle: String? { get }
    var icon: Image { get }
    var isHierarchyEntry: Bool { get }
}

struct AssetClassificationHierarchyObject: FlatHierarchyObjectModel {

    // MARK: - Public Properties
    let id: UUID
    let title: String
    let subtitle: String?
    let icon: Image
    let wrappedType: String
    
    // MARK: FlatHierarchyObjectModel
    let isHierarchyEntry: Bool
    let hierarchyLevel: Int
    let hasParent: Bool
    let disableMovement: Bool
    let disableDeletion: Bool
    
    // MARK: - Initialization
    init<T: AssetClassificationHierarchyObjectModel>(object: T, hierarchyLevel: Int, hasParent: Bool, disableMovement: Bool, disableDeletion: Bool) {
        self.id = object.id
        self.title = object.title
        self.subtitle = object.subtitle
        self.icon = object.icon
        self.wrappedType = "\(type(of: object))"
        
        self.isHierarchyEntry = object.isHierarchyEntry
        self.hierarchyLevel = hierarchyLevel
        self.hasParent = hasParent
        self.disableMovement = disableMovement
        self.disableDeletion = disableDeletion
    }
    
}

struct AssetClassificationHierarchyObjectView: View {
    
    // MARK: - Public Properties
    let object: AssetClassificationHierarchyObject
    
    // MARK: - View
    var body: some View {
        HStack {
            self.object.icon
        
            VStack(alignment: .leading) {
                if (self.object.subtitle != nil) {
                    Text(self.object.subtitle!)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Text(self.object.title)
            }
            .padding(.leading, Length(integerLiteral: 8))
        }
    }
    
}
