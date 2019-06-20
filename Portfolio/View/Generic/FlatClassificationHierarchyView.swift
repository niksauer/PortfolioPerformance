//
//  FlatClassificationHierarchyView.swift
//  Portfolio
//
//  Created by Nik Sauer on 20.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import Foundation
import SwiftUI

protocol FlatClassificationHierarchyViewModel: ClassificationHierarchyViewModel {
    func getFlatClassificationHierarchy(type: ClassificationType) -> [HierarchyObject]
}

struct FlatClassificationHierarchyView<T: FlatClassificationHierarchyViewModel>: View {
    
    // MARK: - Public Properties
    @ObjectBinding var viewModel: T
    
    // MARK: - View
    var body: some View {
        List {
            ForEach(self.viewModel.getFlatClassificationHierarchy(type: self.viewModel.classificationType).identified(by: \.id)) { flatHierarchyObject in
                self.viewModel.getHierarchyObjectView(flatHierarchyObject)
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
    
    // MARK: - Private Methods
    private func getIndentPadding(object: T.HierarchyObject) -> Int {
        let basePadding = 20
        let folderPadding = object.hierarchyLevel * basePadding
        let entryPadding = object.hasParent ? (object.isHierarchyEntry ? basePadding : 0) : 0
        
        return folderPadding + entryPadding
    }
    
}
