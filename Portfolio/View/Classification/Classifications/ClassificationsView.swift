//
//  ClassificationsView.swift
//  Portfolio
//
//  Created by Nik Sauer on 10.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct ClassificationsView: View {
    
    // MARK: - Public Properties
    @ObjectBinding var viewModel: ClassificationsViewModel
    
    // MARK: - Private Properties
    @State private var showNewEntryDialog = false
    
    // MARK: - View
    var body: some View {
        NavigationView {
            ClassificationHierarchyView(viewModel: self.viewModel, listStyle: .plain, style: "Default")
                .navigationBarTitle(Text(self.viewModel.classificationType.rawValue), displayMode: .inline)
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
                                            // TODO: create new classification
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
struct ClassificationsView_Previews : PreviewProvider {
    static let viewModel = ClassificationsViewModel(classificationType: .AssetAllocation)

    static var previews: some View {
        return ClassificationsView(viewModel: viewModel)
    }
}
#endif
