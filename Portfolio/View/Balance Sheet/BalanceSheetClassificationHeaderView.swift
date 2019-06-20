//
//  BalanceSheetClassificationHeaderView.swift
//  Portfolio
//
//  Created by Nik Sauer on 20.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct BalanceSheetClassificationHeaderView: View {
    
    // MARK: - Public Properties
    let classification: Classification
    let totalAssetValue: Double
    let totalShare: Double
    let currency: Currency
    
    // MARK: - Private Properties
    private let numberFormatter = getNumberFormatter()
    
    // MARK: - View
    var body: some View {
        let totalAssetValueString = suffixNumber(self.totalAssetValue)
        let totalShareString = self.numberFormatter.string(from: NSNumber(value: totalShare)) ?? "?"
        
        return HStack {
            Text(classification.name)
                .bold()
                .foregroundColor(.primary)
            
            Spacer()
            
            Text("\(totalAssetValueString)\(currency.rawValue)")
            Text("/")
            Text("\(totalShareString)%")
        }
    }
    
}

//#if DEBUG
//struct BalanceSheetClassificationHeaderView_Previews : PreviewProvider {
//    static var previews: some View {
//        BalanceSheetClassificationHeaderView()
//    }
//}
//#endif
