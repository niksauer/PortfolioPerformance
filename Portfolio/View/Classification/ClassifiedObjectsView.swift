//
//  ClassifiedObjectsView.swift
//  Portfolio
//
//  Created by Nik Sauer on 08.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct ClassifiedObjectsView: View {

    // MARK: - Public Properties
    @EnvironmentObject var assetStore: AssetStore
    @State var classificationType: ClassificationType
    
    // MARK: - Private Properties
    @State private var showClassificationTypeSelection = false
    
    private var classificationTypeActionSheet: ActionSheet {
        var actions: [ActionSheet.Button] = assetStore.classificationTypes.map { classificationType in
            .default(Text(classificationType.rawValue)) {
                self.showClassificationTypeSelection = false
                self.classificationType = classificationType
            }
        }
        
        actions.append(.cancel { self.showClassificationTypeSelection = false })
            
        return ActionSheet(title: Text("Klassifizierungstyp"), buttons: actions)
    }
    
    // MARK: - View
    var body: some View {
        List {
            Section(header: Text(self.classificationType.rawValue).bold()) {
                ForEach(self.assetStore.getFlatClassificationHierarchy(type: self.classificationType, includeEntries: true)) { classifiedObject in
                    HierarchyObjectRow(object: classifiedObject, disableClassificationMovement: true, disableEntryMovement: false)
                }
                .onMove(perform: { source, destination in
                    self.assetStore.moveClassifiedObject(from: source, to: destination, classificationHierarchyType: self.classificationType, showsEntries: true)
                })
            }
            
            Section(header: Text("Ohne Klassifizierung").bold()) {
                ForEach(self.assetStore.getUnclassifiedObjects(type: self.classificationType)) { unclassifiedObject in
                    HierarchyObjectRow(object: unclassifiedObject, disableClassificationMovement: true, disableEntryMovement: false)
                }
                .onMove(perform: { source, destination in
                    self.assetStore.moveUnclassifiedObject(from: source, to: destination)
                })
            }
        }
//        .listStyle(.grouped)
        .navigationBarTitle(Text("Klassifizierung"), displayMode: .inline)
        .navigationBarItems(
            leading:
                HStack {
                    Button(action: {
                        self.showClassificationTypeSelection = true
                    }) {
                        Image(systemName: "list.bullet")
                    }
                    .presentation(self.showClassificationTypeSelection ? classificationTypeActionSheet : nil)
                    
                    PresentationButton(Image(systemName: "folder.badge.plus"), destination: ClassificationsView(classificationType: self.classificationType).environmentObject(assetStore))
                        .padding(.leading)
                },
            trailing:
                EditButton()
        )
        .tabItemLabel(Text("Klassifizierung")) // Image(systemName: "chart.pie.fill")
    }

}

//#if DEBUG
//struct FortuneView_Previews : PreviewProvider {
//    static let assetStore = AssetStore(securities: securities, accounts: accounts, classifications: classifications, securityClassifications: securityClassifications)
//    
//    static var previews: some View {
//        ClassifiedObjectsView(classificationType: .AssetAllocation)
//            .environmentObject(assetStore)
//    }
//}
//#endif
