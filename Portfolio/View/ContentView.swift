//
//  ContentView.swift
//  Portfolio
//
//  Created by Nik Sauer on 07.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let assetStore = AssetStore()
    
    var body: some View {
        NavigationView {
            ClassifiedObjectsView(classificationType: .AssetAllocation)
                .environmentObject(assetStore)
        }
    }
}

//#if DEBUG
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//#endif
