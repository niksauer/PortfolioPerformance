//
//  ContentView.swift
//  Portfolio
//
//  Created by Nik Sauer on 07.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let assetClassificationViewModel = AssetClassificationViewModel()
    let balanceSheetViewModel = BalanceSheetViewModel()
    
    var body: some View {        
        return NavigationView {
//            AssetClassificationView(viewModel: assetClassificationViewModel)
            BalanceSheetView(viewModel: balanceSheetViewModel)
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
