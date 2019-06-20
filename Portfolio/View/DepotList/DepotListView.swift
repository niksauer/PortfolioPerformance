//
//  DepotListView.swift
//  Portfolio
//
//  Created by Nik Sauer on 20.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct DepotListView: View {
    let depots: [Depot]
    
    var body: some View {
        List(self.depots) { depot in
            DepotRowView(depot: depot)
        }
        .listStyle(GroupedListStyle.Member.grouped)
        .navigationBarTitle(Text("Depots"))
        .navigationBarItems(trailing: Button(action: create) { Image(systemName: "plus.circle") })
        .tabItemLabel(Text("Depots")) // Image(systemName: "briefcase")
    }
    
    private func create() {
        
    }
}

//#if DEBUG
//struct DepotListView_Previews: PreviewProvider {
//    static var previews: some View {
//        DepotListView()
//    }
//}
//#endif
