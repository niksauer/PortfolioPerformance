//
//  ClassificationHierarchyView.swift
//  Portfolio
//
//  Created by Nik Sauer on 14.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

protocol FlatHierarchyObjectModel: Identifiable {
    var title: String { get }
    
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
    
    var classificationType: ClassificationType { get }
    
    func getRootClassificationObjects(type: ClassificationType) -> [FlatHierarchyObject]
    func getFlatClassificationHierarchy(type: ClassificationType) -> [FlatHierarchyObject]
    func getFlatClassificationHierarchy(type: ClassificationType, root: FlatHierarchyObject) -> [FlatHierarchyObject]
    func getFlatHierarchyObjectView(_ object: FlatHierarchyObject) -> FlatHierarchyObjectView
    func moveHierarchyObject(from: IndexSet, to: Int)
    func deleteHierarchyObject(at: IndexSet)
}

extension ClassificationHierarchyViewModel {
    func getRootClassificationObjects(type: ClassificationType) -> [FlatHierarchyObject] { return [] }
    func getFlatClassificationHierarchy(type: ClassificationType, root: FlatHierarchyObject) -> [FlatHierarchyObject] { return [] }
    func moveHierarchyObject(from: IndexSet, to: Int) { }
    func deleteHierarchyObject(at: IndexSet) { }
}

enum Style {
    case Default
    case Grouped
}

struct ClassificationHierarchyView<T: ClassificationHierarchyViewModel, S: ListStyle>: View {

    // MARK: - Public Properties
    @ObjectBinding var viewModel: T
    let listStyle: S.Member
    let style: String
    
    // MARK: - View
    var body: some View {
        print(self.style == "Grouped")
        
        return List {
            if self.style == "Grouped" {
                ForEach(self.viewModel.getRootClassificationObjects(type: self.viewModel.classificationType).identified(by: \.id)) { rootClassification in
                    Section(header: Text(rootClassification.title).bold().foregroundColor(.primary)) {
                        ForEach(self.viewModel.getFlatClassificationHierarchy(type: self.viewModel.classificationType, root: rootClassification).identified(by: \.id)) { flatHierarchyObject in
                            self.viewModel.getFlatHierarchyObjectView(flatHierarchyObject)
//                                .padding(.leading, Length(integerLiteral: self.getIndentPadding(object: flatHierarchyObject)))
                                .moveDisabled(flatHierarchyObject.disableMovement)
                                .deleteDisabled(flatHierarchyObject.disableDeletion)
                        }
                    }
                }
            } else {
                ForEach(self.viewModel.getFlatClassificationHierarchy(type: self.viewModel.classificationType).identified(by: \.id)) { flatHierarchyObject in
                    self.viewModel.getFlatHierarchyObjectView(flatHierarchyObject)
                        .padding(.leading, Length(integerLiteral: self.getIndentPadding(object: flatHierarchyObject)))
                        .moveDisabled(flatHierarchyObject.disableMovement)
                        .deleteDisabled(flatHierarchyObject.disableDeletion)
                }
                .onMove(perform: { source, destination in
                    self.viewModel.moveHierarchyObject(from: source, to: destination)
                })
                .onDelete(perform: { source in
                    self.viewModel.deleteHierarchyObject(at: source)
                })
            }
        }
        .listStyle(self.listStyle)
    }
    
    // MARK: - Private Methods
    private func getIndentPadding(object: T.FlatHierarchyObject) -> Int {
        let basePadding = 20
        let folderPadding = object.hierarchyLevel * basePadding
        let entryPadding = object.hasParent ? (object.isHierarchyEntry ? basePadding : 0) : 0
        
        return folderPadding + entryPadding
    }
    
}
