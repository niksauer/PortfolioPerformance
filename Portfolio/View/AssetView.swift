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
//    @Environment(\.editMode) var mode
    
    // MARK: - View
    var body: some View {
        List {
            ForEach(self.assetStore.getRootClassifications(for: self.classificationType)) { rootClassification in
                RootClassificationSection(classification: rootClassification)
            }
        }
        .listStyle(GroupedListStyle.Member.grouped)
        .navigationBarTitle(Text(self.classificationType.rawValue))
        .navigationBarItems(
            leading:
                Button(action: {
                    withAnimation {
                        self.changeClassificationType()
                    }
                }) {
                    Text("Classification")
                },
            trailing:
                EditButton()
        )
        .tabItemLabel(Text("Assets")) // Image(systemName: "chart.pie.fill")
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

struct FortuneRow: View {
    // MARK: - Properties
    let security: Security
    
    // MARK: - View
    var body: some View {
        NavigationButton(destination: SecurityDetailView(security: security)) {
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
}

struct AccountRow: View {
    // MARK: - Properties
    let account: Account
    
    // MARK: - View
    var body: some View {
        NavigationButton(destination: AccountDetailView(account: account)) {
            HStack {
                Text("55")
                    .padding(.all)
                    .background(Color.green, cornerRadius: 12)
                    .foregroundColor(.white)
                
                Text(account.name)
            }
        }
    }
}

struct RootClassificationSection: View {
    // MARK: - Properties
    @EnvironmentObject var assetStore: AssetStore
    let classification: Classification
    
    // MARK: - View
    var body: some View {
        Section(header: Text(classification.name).bold()) {
            ClassificationEntriesView(classification: classification)

            ForEach(self.assetStore.getSubClassifications(for: self.classification)) { subClassification in
                SubClassificationSection(classification: subClassification)
            }
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
            ForEach(self.assetStore.getSecurities(for: self.classification)) { security in
                FortuneRow(security: security)
            }
            .onMove(perform: moveSecurity)
            
            ForEach(self.assetStore.getAccounts(for: self.classification)) { account in
                AccountRow(account: account)
            }
            .onMove(perform: moveAccount)
        }
    }
    
    // MARK: - Private Methods
    private func moveSecurity(from source: IndexSet, to destination: Int) {
    }
    
    private func moveAccount(from source: IndexSet, to destination: Int) {
//        source.sorted { $0 > $1 }.forEach { self.store.accounts.insert(store.rooms.remove(at: $0), at: destination) }
    }
}

struct SubClassificationFolder: View {
    // MARK: - Properties
    let classification: Classification
    let indentLevel: Int
    
    // MARK: - View
    var body: some View {
        HStack {
            Image(systemName: "folder.fill")
            Text(self.classification.name)
        }
        .padding(.leading, Length(integerLiteral: self.indentLevel * 30 - 30))
    }
}

struct SubClassificationSection: View {
    // MARK: - Properties
    @EnvironmentObject var assetStore: AssetStore
    let classification: Classification
    
    // MARK: - View
    var body: some View {
        Group {
            SubClassificationFolder(classification: self.classification, indentLevel: self.assetStore.getIndentLevel(for: classification))
            
            ForEach(self.assetStore.getSecurities(for: self.classification)) { security in
                FortuneRow(security: security)
            }
            .onMove(perform: move)
            
            ForEach(self.assetStore.getSubClassifications(for: self.classification)) { subClassification in
                SubClassificationSection(classification: subClassification)
            }
        }
    }
    
    // MARK: - Private Methods
    func move(from source: IndexSet, to destination: Int) {
        
    }
}