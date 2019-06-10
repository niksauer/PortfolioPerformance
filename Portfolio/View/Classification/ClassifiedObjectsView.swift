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
        var actions: [ActionSheet.Button] = ClassificationType.allCases.map { classificationType in
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
                ForEach(self.assetStore.getRootClassifications(type: self.classificationType)) { rootClassification in
                    ClassificationSection(classification: rootClassification, showEntries: true)
                }
            }
            
            Section(header: Text("Ohne Klassifizierung").bold()) {
                ForEach(self.assetStore.getUnclassifiedSecurities(type: self.classificationType)) { security in
                    NavigationButton(destination: SecurityDetailView(security: security)) {
                        ClassifiedSecurityRow(security: security)
                    }
                }
                .onMove(perform: self.assetStore.moveUnclassifiedSecurity)
                
                ForEach(self.assetStore.getUnclassifiedAccounts(type: self.classificationType)) { account in
                    NavigationButton(destination: AccountDetailView(account: account)) {
                        ClassifiedAccountRow(account: account)
                    }
                }
                .onMove(perform: self.assetStore.moveUnclassifiedAccount)
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

#if DEBUG
struct FortuneView_Previews : PreviewProvider {
    static let assetStore = AssetStore(securities: securities, accounts: accounts, classifications: classifications, transactions: depotTransactions)
    
    static var previews: some View {
        ClassifiedObjectsView(classificationType: .AssetAllocation)
            .environmentObject(assetStore)
    }
}
#endif
