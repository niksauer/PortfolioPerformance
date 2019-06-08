//
//  ContentView.swift
//  Portfolio
//
//  Created by Nik Sauer on 07.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    let securities: [Security]
    
    var body: some View {
        NavigationView {
//                SecurityView(securities: securities)
            FortuneView(store: FortuneStore(securities: securities, classifications: classifications, transactions: depotTransactions))
//                DepotView(depots: depots)
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(securities: securities)
    }
}
#endif
