//
//  ContentView.swift
//  Portfolio
//
//  Created by Nik Sauer on 07.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    let store = AssetStore(securities: securities, accounts: accounts, classifications: classifications, transactions: depotTransactions)
    
    var body: some View {
        NavigationView {
//                SecurityView(securities: securities)
            AssetView(store: store)
//                DepotView(depots: depots)
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
