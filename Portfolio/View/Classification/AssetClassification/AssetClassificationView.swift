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
    @State private var classificationType: AssetClassificationType = .AssetAllocation
    @State private var showClassificationTypeSelection = false
    
    private var classificationTypeActionSheet: ActionSheet {
        var actions: [ActionSheet.Button] = self.viewModel.classificationTypes.map { classificationType in
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
        let classificationsViewModel = ClassificationsViewModel()
        let classificationsView = ClassificationsView(viewModel: classificationsViewModel, classificationType: self.classificationType)
    
        return ClassificationHierarchyView(viewModel: self.viewModel, classificationType: self.$classificationType)
            .navigationBarTitle(Text(self.classificationType.rawValue), displayMode: .inline)
            .navigationBarItems(
                leading:
                    HStack {
                        Button(action: {
                            self.showClassificationTypeSelection = true
                        }) {
                            Image(systemName: "list.bullet")
                        }
                        .presentation(self.showClassificationTypeSelection ? classificationTypeActionSheet : nil)

                        PresentationButton(Image(systemName: "folder.badge.plus"), destination: classificationsView)
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
