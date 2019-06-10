//
//  ContentView.swift
//  Portfolio
//
//  Created by Nik Sauer on 07.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    let assetStore = AssetStore(securities: securities, accounts: accounts, classifications: classifications, transactions: depotTransactions)
    
    var body: some View {
        NavigationView {
            AssetView()
                .environmentObject(assetStore)
//                SecurityView(securities: securities)
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
