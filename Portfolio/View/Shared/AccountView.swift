//
//  AccountView.swift
//  Portfolio
//
//  Created by Nik Sauer on 19.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct AccountView: View {
    
    // MARK: - Public Properties
    let account: Account
    let value: Double = 3463
    
    // MARK: - Private Properties
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    // MARK: - View
    var body: some View {
        let valueString = suffixNumber(self.value)
        
        return HStack {
            VStack {
                Text("\(valueString)\(self.account.currency.rawValue)")
                    .font(.headline)
            }
            .padding(.all, 15)
            .background(Color.gray, cornerRadius: 12)
            .foregroundColor(.white)
            
            Text(self.account.name)
        }
    }

}
//
//#if DEBUG
//struct AccountView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccountRow()
//    }
//}
//#endif
