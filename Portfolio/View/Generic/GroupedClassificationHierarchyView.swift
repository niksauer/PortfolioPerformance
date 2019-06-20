//
//  GroupedClassificationHierarchyView.swift
//  Portfolio
//
//  Created by Nik Sauer on 20.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import Foundation
import SwiftUI

protocol ClassificationObjectModel: Identifiable {
    var name: String { get }
}

protocol GroupedClassificationHierarchyViewModel: ClassificationHierarchyViewModel {
    associatedtype ClassificationObject: ClassificationObjectModel
    associatedtype ClassificationObjectView: View
    
    func getClassificationObjects(type: ClassificationType) -> [ClassificationObject]
    func getFlatClassificationHierarchy(type: ClassificationType, classification: ClassificationObject) -> [HierarchyObject]
    
    func getClassificationObjectView(_ classification: ClassificationObject) -> ClassificationObjectView
}

struct GroupedClassificationHierarchyView<T: GroupedClassificationHierarchyViewModel>: View {
    
    // MARK: - Public Properties
    @ObjectBinding var viewModel: T
    
    // MARK: - View
    var body: some View {
        List {
            ForEach(self.viewModel.getClassificationObjects(type: self.viewModel.classificationType).identified(by: \.id)) { classification in
                Section(header: self.viewModel.getClassificationObjectView(classification)) {
                    ForEach(self.viewModel.getFlatClassificationHierarchy(type: self.viewModel.classificationType, classification: classification).identified(by: \.id)) { hierarchyObject in
                        self.viewModel.getHierarchyObjectView(hierarchyObject)
                            .moveDisabled(hierarchyObject.disableMovement)
                            .deleteDisabled(hierarchyObject.disableDeletion)
                    }
                }
            }
            .onMove(perform: { source, destination in
                self.viewModel.moveHierarchyObject(from: source, to: destination)
            })
            .onDelete(perform: { source in
                self.viewModel.deleteHierarchyObject(at: source)
            })
        }
        .listStyle(.grouped)
    }
    
}
