//
//  ClassificationSection.swift
//  Portfolio
//
//  Created by Nik Sauer on 10.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

protocol HierarchyObject: Identifiable where ID == UUID {
    var title: String { get }
    var subtitle: String? { get }
    var icon: Image { get }
    var isHierarchyEntry: Bool { get }
}

struct FlatHierarchyObject: Identifiable {
    
    // MARK: - Public Properties
    let id: UUID
    let title: String
    let subtitle: String?
    let icon: Image
    let isHierarchyEntry: Bool
    let wrappedType: String
    
    let hierarchyLevel: Int
    let hasParent: Bool
    
    // MARK: - Initialization
    init<T: HierarchyObject>(object: T, hierarchyLevel: Int, hasParent: Bool) {
        self.id = object.id
        self.title = object.title
        self.subtitle = object.subtitle
        self.icon = object.icon
        self.isHierarchyEntry = object.isHierarchyEntry
        self.wrappedType = "\(type(of: object))"
        
        self.hierarchyLevel = hierarchyLevel
        self.hasParent = hasParent
    }
    
}

struct HierarchyObjectRow: View {
    
    // MARK: - Public Properties
    let object: FlatHierarchyObject
    let disableClassificationMovement: Bool
    let disableEntryMovement: Bool
    
    // MARK: - Private Properties
    private var disableMovement: Bool {
        return !object.isHierarchyEntry && disableClassificationMovement || object.isHierarchyEntry && disableEntryMovement
    }
    
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
        .padding(.leading, Length(integerLiteral: self.getIndentPadding()))
        .moveDisabled(self.disableMovement)
    }
    
    // MARK: - Private Methods
    private func getIndentPadding() -> Int {
        let basePadding = 20
        let folderPadding = object.hierarchyLevel * basePadding
        let entryPadding = object.hasParent ? (object.isHierarchyEntry ? basePadding : 0) : 0
        
        return folderPadding + entryPadding
    }
    
}
