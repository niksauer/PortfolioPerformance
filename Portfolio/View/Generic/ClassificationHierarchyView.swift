//
//  ClassificationHierarchyView.swift
//  Portfolio
//
//  Created by Nik Sauer on 14.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

protocol FlatHierarchyObjectModel: Identifiable {
    var isHierarchyEntry: Bool { get }
    var hierarchyLevel: Int { get }
    var hasParent: Bool { get }
    
    var disableMovement: Bool { get }
    var disableDeletion: Bool { get }
}

protocol ClassificationHierarchyViewModel: BindableObject {
    associatedtype ClassificationType
    associatedtype FlatHierarchyObject: FlatHierarchyObjectModel
    associatedtype FlatHierarchyObjectView: View
    
    func getFlatClassificationHierarchy(type: ClassificationType) -> [FlatHierarchyObject]
    func getFlatHierarchyObjectView(_ object: FlatHierarchyObject) -> FlatHierarchyObjectView
    func moveHierarchyObject(from: IndexSet, to: Int, classificationType: ClassificationType)
    func deleteHierarchyObject(at: IndexSet, classificationType: ClassificationType)
}

struct ClassificationHierarchyView<T: ClassificationHierarchyViewModel>: View {

    // MARK: - Public Properties
    @ObjectBinding var viewModel: T
    @Binding var classificationType: T.ClassificationType

    // MARK: - View
    var body: some View {
        List {
            ForEach(self.viewModel.getFlatClassificationHierarchy(type: self.classificationType).identified(by: \.id)) { flatHierarchyObject in
                self.viewModel.getFlatHierarchyObjectView(flatHierarchyObject)
                    .padding(.leading, Length(integerLiteral: self.getIndentPadding(object: flatHierarchyObject)))
                    .moveDisabled(flatHierarchyObject.disableMovement)
                    .deleteDisabled(flatHierarchyObject.disableDeletion)
            }
            .onMove(perform: { source, destination in
                self.viewModel.moveHierarchyObject(from: source, to: destination, classificationType: self.classificationType)
            })
            .onDelete(perform: { source in
                self.viewModel.deleteHierarchyObject(at: source, classificationType: self.classificationType)
            })
        }
//        .listStyle(.grouped)
    }
    
    // MARK: - Private Methods
    private func getIndentPadding(object: T.FlatHierarchyObject) -> Int {
        let basePadding = 20
        let folderPadding = object.hierarchyLevel * basePadding
        let entryPadding = object.hasParent ? (object.isHierarchyEntry ? basePadding : 0) : 0
        
        return folderPadding + entryPadding
    }
    
}
