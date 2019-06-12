//
//  ClassificationsView.swift
//  Portfolio
//
//  Created by Nik Sauer on 10.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct ClassificationsView : View {
    
    // MARK: - Public Properties
    @EnvironmentObject var assetStore: AssetStore
    let classificationType: ClassificationType
    
    // MARK: - Private Properties
    @State private var showNewEntryDialog = false
    
    // MARK: - View
    var body: some View {
        NavigationView {
            List {
                ForEach(self.assetStore.getFlatClassificationHierarchy(type: self.classificationType, includeEntries: false)) { classifiedObject in
                    HierarchyObjectRow(object: classifiedObject, disableClassificationMovement: false, disableEntryMovement: true)
                }
                .onMove(perform: { source, destination in
                    self.assetStore.moveClassifiedObject(from: source, to: destination, classificationHierarchyType: self.classificationType, showsEntries: false)
                })
                .onDelete(perform: { source in
                    self.assetStore.deleteClassification(at: source)
                })
            }
            .navigationBarTitle(Text(self.classificationType.rawValue), displayMode: .inline)
            .navigationBarItems(
                leading:
                    HStack {
                        Button(action: {
                            self.showNewEntryDialog = true
                        }) {
                            Image(systemName: "plus.circle")
                        }
                        .presentation($showNewEntryDialog) {
                            Alert(
                                title: Text("New Classification"),
                                primaryButton: .default(Text("Create")) {
                                    // create classification
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    },
                trailing:
                    EditButton()
            )
        }
    }
}

#if DEBUG
struct ClassificationView_Previews : PreviewProvider {
    static var previews: some View {
        ClassificationsView(classificationType: .AssetAllocation)
    }
}
#endif
