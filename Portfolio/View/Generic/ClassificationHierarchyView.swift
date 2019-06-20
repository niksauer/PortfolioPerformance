//
//  ClassificationHierarchyView.swift
//  Portfolio
//
//  Created by Nik Sauer on 14.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

protocol HierarchyObjectModel: Identifiable {
    var isHierarchyEntry: Bool { get }
    var hierarchyLevel: Int { get }
    var hasParent: Bool { get }
    
    var disableMovement: Bool { get }
    var disableDeletion: Bool { get }
}

protocol ClassificationHierarchyViewModel: BindableObject {
    associatedtype ClassificationType
    associatedtype HierarchyObject: HierarchyObjectModel
    associatedtype HierarchyObjectView: View
    
    var classificationType: ClassificationType { get }
    
    func getHierarchyObjectView(_ object: HierarchyObject) -> HierarchyObjectView
    
    func moveHierarchyObject(from: IndexSet, to: Int)
    func deleteHierarchyObject(at: IndexSet)
}

extension ClassificationHierarchyViewModel {
    func moveHierarchyObject(from: IndexSet, to: Int) { }
    func deleteHierarchyObject(at: IndexSet) { }
}
