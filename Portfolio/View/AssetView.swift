//
//  AssetView.swift
//  Portfolio
//
//  Created by Nik Sauer on 08.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct AssetView: View {

    // MARK: - Properties
    @EnvironmentObject var assetStore: AssetStore
    @State private var classificationType: ClassificationType = .AssetAllocation
    @State private var showClassificationTypeSelection = false
    @Environment(\.editMode) var mode
    
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
                    ClassificationSection(classification: rootClassification)
                }
            }
            
            Section(header: Text("Ohne Klassifizierung").bold()) {
                ForEach(self.assetStore.getUnclassifiedSecurities(type: self.classificationType)) { security in
                    NavigationButton(destination: SecurityDetailView(security: security)) {
                        AssetSecurityRow(security: security)
                    }
                }
                .onMove(perform: AssetViewHelper.moveSecurity)
                
                ForEach(self.assetStore.getUnclassifiedAccounts(type: self.classificationType)) { account in
                    NavigationButton(destination: AccountDetailView(account: account)) {
                        AssetAccountRow(account: account)
                    }
                }
                .onMove(perform: AssetViewHelper.moveAccount)
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
                    
                    Image(systemName: "folder.badge.plus")
                        .padding(.leading, Length(integerLiteral: 8))
                        .foregroundColor(.accentColor)
                },
            trailing:
                EditButton()
        )
        .tabItemLabel(Text("Klassifizierung")) // Image(systemName: "chart.pie.fill")
    }
    
    // MARK: - Private Methods
    private func changeClassificationType() {
        // show classification picker view
        if case ClassificationType.AssetAllocation = self.classificationType {
            self.classificationType = .InvestmentType
        } else {
            self.classificationType = .AssetAllocation
        }
    }
    
}

#if DEBUG
struct FortuneView_Previews : PreviewProvider {
    static let assetStore = AssetStore(securities: securities, accounts: accounts, classifications: classifications, transactions: depotTransactions)
    
    static var previews: some View {
        AssetView()
            .environmentObject(assetStore)
    }
}
#endif

struct AssetViewHelper {

    // MARK: - Properties
    static let basePadding = 20
    
    // MARK: - Public Methods
    static func getIndentPadding(level: Int, isEntry: Bool) -> Int {
        let folderPadding = level * basePadding
        //    let entryPadding = (isEntry ? basePadding : 0)
        
        return folderPadding
    }
    
    static func moveSecurity(from source: IndexSet, to destination: Int) {
        
    }
    
    static func moveAccount(from source: IndexSet, to destination: Int) {
        //        source.sorted { $0 > $1 }.forEach { self.store.accounts.insert(store.rooms.remove(at: $0), at: destination) }
    }
    
}

struct AssetSecurityRow: View {
    
    // MARK: - Properties
    let security: Security
    
    // MARK: - View
    var body: some View {
        HStack {
            Text("55")
                .padding(.all)
                .background(Color.green, cornerRadius: 12)
                .foregroundColor(.white)
            
            VStack(alignment: .leading) {
                if (security.supplier != nil) {
                    Text(security.supplier!)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text(security.name)
            }
            
            Spacer()
            
            Image(systemName: "arrowtriangle.up.fill")
                .foregroundColor(.green)
        }
    }
    
}

struct AssetAccountRow: View {
    
    // MARK: - Properties
    let account: Account
    
    // MARK: - View
    var body: some View {
        HStack {
            Text("55")
                .padding(.all)
                .background(Color.green, cornerRadius: 12)
                .foregroundColor(.white)
            
            Text(account.name)
        }
    }
    
}

struct ClassificationFolder: View {
    
    // MARK: - Properties
    let classification: Classification
    
    // MARK: - View
    var body: some View {
        HStack {
            Image(systemName: "folder.fill")
            Text(self.classification.name)
        }
    }
    
}

struct ClassificationEntriesView: View {
    
    // MARK: - Properties
    @EnvironmentObject var assetStore: AssetStore
    let classification: Classification
    
    // MARK: - View
    var body: some View {
        Group {
            ForEach(self.assetStore.getSecurities(classification: self.classification)) { security in
                NavigationButton(destination: SecurityDetailView(security: security)) {
                    AssetSecurityRow(security: security)
                }
            }
            .onMove(perform: AssetViewHelper.moveSecurity)
            
            ForEach(self.assetStore.getAccounts(classification: self.classification)) { account in
                NavigationButton(destination: AccountDetailView(account: account)) {
                    AssetAccountRow(account: account)
                }
            }
            .onMove(perform: AssetViewHelper.moveAccount)
        }
    }
    
}

struct ClassificationSection: View {
    
    // MARK: - Properties
    @EnvironmentObject var assetStore: AssetStore
    let classification: Classification
    
    var indentLevel: Int {
        return assetStore.getHierarchyLevel(of: classification)
    }
    
    // MARK: - View
    var body: some View {
        Group {
            ClassificationFolder(classification: self.classification)
                .padding(.leading, Length(integerLiteral: AssetViewHelper.getIndentPadding(level: self.indentLevel, isEntry: false)))
            
            ClassificationEntriesView(classification: self.classification)
                .padding(.leading, Length(integerLiteral: AssetViewHelper.getIndentPadding(level: self.indentLevel, isEntry: true)))
            
            ForEach(self.assetStore.getSubClassifications(of: self.classification)) { subClassification in
                ClassificationSection(classification: subClassification)
            }
        }
    }
    
}
