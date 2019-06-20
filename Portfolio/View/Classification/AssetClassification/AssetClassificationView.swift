//
//  AssetClassificationView.swift
//  Portfolio
//
//  Created by Nik Sauer on 08.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct AssetClassificationView: View {

    // MARK: - Public Properties
    @ObjectBinding var viewModel: AssetClassificationViewModel
    
    // MARK: - Private Properties
    @State private var showClassificationTypeSelection = false
    
    private var classificationTypeActionSheet: ActionSheet {
        var actions: [ActionSheet.Button] = self.viewModel.classificationTypes.map { classificationType in
            .default(Text(classificationType.rawValue)) {
                self.showClassificationTypeSelection = false
                self.viewModel.classificationType = classificationType
            }
        }
        
        actions.append(.cancel { self.showClassificationTypeSelection = false })
        
        return ActionSheet(title: Text("Klassifizierungstyp"), buttons: actions)
    }
    
    // MARK: - View
    var body: some View {
        let classificationListViewModel = ClassificationListViewModel(classificationType: self.viewModel.classificationType)
        let classificationListView = ClassificationListView(viewModel: classificationListViewModel)
    
        return FlatClassificationHierarchyView(viewModel: self.viewModel)
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

                        PresentationButton(destination: classificationListView, label: { Image(systemName: "folder.badge.plus") })
                            .padding(.leading)
                    },
                trailing:
                    EditButton()
            )
    }

}

#if DEBUG
struct AssetClassificationView_Previews: PreviewProvider {
    static let viewModel = AssetClassificationViewModel()

    static var previews: some View {
        return AssetClassificationView(viewModel: viewModel)
    }
}
#endif
