//
//  FortuneView.swift
//  Portfolio
//
//  Created by Nik Sauer on 08.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct FortuneStore {
    var securities: [Security]
    var classifications: [Classification]
    var transactions: [DepotTransaction]
    
    init(securities: [Security], classifications: [Classification], transactions: [DepotTransaction]) {
        self.securities = securities
        
        self.classifications = classifications
        let stockClassification = Classification(name: "Aktien", type: .AssetAllocation, parentID: classifications[0].id)
        self.classifications.append(stockClassification)
        self.classifications.append(Classification(name: "Aktien Industrieländer", type: .AssetAllocation, parentID: stockClassification.id, securities: Set(arrayLiteral: securities[2].id)))
        self.classifications.append(Classification(name: "Immobilien", type: .AssetAllocation, parentID: classifications[0].id))
        
        self.transactions = transactions
    }
    
    var rootClassifications: [Classification] {
        return classifications.filter { $0.parentID == nil }
    }
    
    func getSecurities(for classification: Classification) -> [Security]  {
        return securities.filter { classification.securities.contains($0.id) }
    }
    
    func getSubClassifications(for classification: Classification) -> [Classification] {
        return classifications.filter { $0.parentID == classification.id }
    }
    
    func getIndentLevel(for classification: Classification) -> Int {
        guard let parentID = classification.parentID, let parent = classifications.first(where: { $0.id == parentID }) else {
            return 0
        }
        
        return 1 + getIndentLevel(for: parent)
    }
}

struct FortuneView: View {
    var store: FortuneStore
    @State private var classificationType: ClassificationType = .AssetAllocation

    var body: some View {
        List {
            ForEach(self.store.rootClassifications) { classification in
                Section(header: Text(classification.name)) {
                    ForEach(self.store.getSecurities(for: classification)) { security in
                        FortuneRow(security: security)
                    }
                    
                    ForEach(self.store.getSubClassifications(for: classification)) { classification in
                        ClassificationRow(classification: classification, indentLevel: self.store.getIndentLevel(for: classification))
                        
                        ForEach(self.store.getSecurities(for: classification)) { security in
                            FortuneRow(security: security)
                        }
                        
                        ForEach(self.store.getSubClassifications(for: classification)) { classification in
                            ClassificationRow(classification: classification, indentLevel: self.store.getIndentLevel(for: classification))
                            
                            ForEach(self.store.getSecurities(for: classification)) { security in
                                FortuneRow(security: security)
                            }
                        }
                    }
                }
            }
            .onMove(perform: move)
        }
        .listStyle(GroupedListStyle.Member.grouped)
        .navigationBarTitle(Text("Fortune"))
        .navigationBarItems(
            leading:
                Button(action: changeClassificationType) {
                    Text("Classification")
                },
            trailing:
                EditButton()
        )
        .tabItemLabel(Text("Fortune")) // Image(systemName: "chart.pie.fill")
    }
    
//    private func getSectionRows(for classification: Classification) -> View {
//        ForEach(self.store.getSecurities(for: classification)) { security in
//            FortuneRow(security: security)
//        }
//
//        ForEach(self.store.getSubClassifications(for: classification)) { classification in
//            ClassificationRow(classification: classification, indentLevel: self.store.getIndentLevel(for: classification))
//        }
//    }
    
    private func changeClassificationType() {
        // show classification picker view
        self.classificationType = .AssetType
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        
    }
}

#if DEBUG
struct FortuneView_Previews : PreviewProvider {
    static var previews: some View {
        FortuneView(store: FortuneStore(securities: securities, classifications: classifications, transactions: depotTransactions))
    }
}
#endif


struct FortuneRow: View {
    let security: Security
    
    var body: some View {
        HStack {
            Text("55")
                .padding(.all, 15)
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

struct ClassificationRow: View {
    let classification: Classification
    let indentLevel: Int
    
    var body: some View {
        NavigationButton(destination: ClassificationDetailView(classification: classification)) {
            HStack {
                Image(systemName: "folder.fill")
                Text(self.classification.name)
            }
            .padding(.leading, Length(integerLiteral: self.indentLevel * 30 - 30))
        }
        
    }
}

struct ClassificationDetailView: View {
    let classification: Classification
    
    var body: some View {
        Text(classification.name)
    }
}
