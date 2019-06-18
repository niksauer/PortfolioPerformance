//
//  BalanceSheetView.swift
//  Portfolio
//
//  Created by Nik Sauer on 14.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct BalanceSheetView: View {
    
    // MARK: - Public Properties
    @ObjectBinding var viewModel: BalanceSheetViewModel

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
    
    var body: some View {
        ClassificationHierarchyView(viewModel: self.viewModel)
            .navigationBarTitle(Text("Vermögensaufstellung"), displayMode: .inline)
            .navigationBarItems(
                leading:
                    HStack {
                        Button(action: {
                            self.showClassificationTypeSelection = true
                        }) {
                            Image(systemName: "list.bullet")
                        }
                        .presentation(self.showClassificationTypeSelection ? classificationTypeActionSheet : nil)

                    }
            )
    }
}

//#if DEBUG
//struct BalanceSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        BalanceSheetView()
//    }
//}
//#endif
