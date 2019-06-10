//
//  ClassificationSection.swift
//  Portfolio
//
//  Created by Nik Sauer on 10.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct ClassificationSection: View {
    
    // MARK: - Public Properties
    @EnvironmentObject var assetStore: AssetStore
    let classification: Classification
    let showEntries: Bool
    
    var indentLevel: Int {
        return assetStore.getHierarchyLevel(of: classification)
    }
    
    // MARK: - View
    var body: some View {
        Group {
            ClassificationFolder(classification: self.classification)
                .padding(.leading, Length(integerLiteral: self.getIndentPadding(level: self.indentLevel, isEntry: false)))
            
            if self.showEntries {
                ClassificationEntriesView(classification: self.classification)
                    .padding(.leading, Length(integerLiteral: self.getIndentPadding(level: self.indentLevel, isEntry: true)))
            }
            
            ForEach(self.assetStore.getSubClassifications(of: self.classification)) { subClassification in
                ClassificationSection(classification: subClassification, showEntries: self.showEntries)
            }
        }
    }
    
    // MARK: - Private Methods
    func getIndentPadding(level: Int, isEntry: Bool) -> Int {
        let basePadding = 20
        let folderPadding = level * basePadding
        //    let entryPadding = (isEntry ? basePadding : 0)
        
        return folderPadding
    }
    
}

#if DEBUG
struct ClassificationSection_Previews : PreviewProvider {
    static var previews: some View {
        ClassificationSection(classification: classifications[0], showEntries: true)
    }
}
#endif

struct ClassificationFolder: View {
    
    // MARK: - Public Properties
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
    
    // MARK: - Public Properties
    @EnvironmentObject var assetStore: AssetStore
    let classification: Classification
    
    // MARK: - View
    var body: some View {
        Group {
            ForEach(self.assetStore.getSecurities(classification: self.classification)) { security in
                NavigationButton(destination: SecurityDetailView(security: security)) {
                    ClassifiedSecurityRow(security: security)
                }
            }
            .onMove(perform: self.assetStore.moveSecurity)
            
            ForEach(self.assetStore.getAccounts(classification: self.classification)) { account in
                NavigationButton(destination: AccountDetailView(account: account)) {
                    ClassifiedAccountRow(account: account)
                }
            }
            .onMove(perform: self.assetStore.moveAccount)
        }
    }
    
}

struct ClassifiedSecurityRow: View {
    
    // MARK: - Public Properties
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

struct ClassifiedAccountRow: View {
    
    // MARK: - Public Properties
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

