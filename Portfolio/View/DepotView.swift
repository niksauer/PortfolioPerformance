//
//  DepotView.swift
//  Portfolio
//
//  Created by Nik Sauer on 08.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct DepotView: View {
    let depots: [Depot]
    
    var body: some View {
        List(self.depots) { depot in
            DepotRow(depot: depot)
        }
        .listStyle(GroupedListStyle.Member.grouped)
        .navigationBarTitle(Text("Depots"))
        .navigationBarItems(trailing: Button(action: create) { Image(systemName: "plus.circle") })
        .tabItemLabel(Text("Depots")) // Image(systemName: "briefcase")
    }
    
    private func create() {
        
    }
}

#if DEBUG
struct DepotView_Previews : PreviewProvider {
    static var previews: some View {
        DepotView(depots: depots)
    }
}
#endif


struct DepotRow: View {
    let depot: Depot
    
    var body: some View {
        HStack {
            Text(self.depot.name)
        }
    }
}

struct DepotDetailView: View {
    let depot: Depot
    
    var body: some View {
        HStack {
            Text(self.depot.name)
        }
    }
}

struct AccountDetailView: View {
    let account: Account
    
    var body: some View {
        HStack {
            Text(self.account.name)
        }
    }
}
