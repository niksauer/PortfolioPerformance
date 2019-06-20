//
//  ClassifiedObjectsView.swift
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
        let classificationsViewModel = ClassificationsViewModel(classificationType: self.viewModel.classificationType)
        let classificationsView = ClassificationsView(viewModel: classificationsViewModel)
    
        return ClassificationHierarchyView(viewModel: self.viewModel, listStyle: .plain, style: "Default")
            .navigationBarTitle(Text(self.viewModel.classificationType.rawValue), displayMode: .inline)
            .navigationBarItems(
                leading:
                    HStack {
                        
                        Button(action: {
                            self.showClassificationTypeSelection = true
                        }) {
                            Image(systemName: "list.bullet")
                        }
                        .presentation(self.showClassificationTypeSelection ? classificationTypeActionSheet : nil)

                        PresentationButton(destination: classificationsView, label: { Image(systemName: "folder.badge.plus") })
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
