//
//  SecurityRowView.swift
//  Portfolio
//
//  Created by Nik Sauer on 08.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct SecurityRowView: View {
    
    // MARK: - Public Properties
    let security: Security
    let amount: Double? = 23.2
    let currentExchangeRate: Double = 223
    let prevousExchangeRate: Double = 220
    let currency: Currency = .EUR
    
    // MARK: - Private Properties
    private var value: Double? { return amount != nil ? amount! * currentExchangeRate : nil }
    private var changePercentage: Double { return (currentExchangeRate / prevousExchangeRate * 100) - 100 }
    
    private let numberFormatter = getNumberFormatter()
    
    // MARK: - View
    var body: some View {
        let valueString = self.value != nil ? suffixNumber(self.value!) : ""
        let exchangeRateString = self.numberFormatter.string(from: NSNumber(value: self.currentExchangeRate)) ?? "?"
        let changePercentageString = self.numberFormatter.string(from: NSNumber(value: self.changePercentage)) ?? "?"
        
        return NavigationButton(destination: SecurityDetailView(security: security)) {
            HStack {
                VStack {
                    Text(valueString)
                        .font(.headline)
                    Text("\(exchangeRateString)\(self.currency.rawValue)")
                        .font(.subheadline)
                }
                .padding(.all, 15)
                .background(Color.gray, cornerRadius: 12)
                .foregroundColor(.white)
                
                VStack(alignment: .leading) {
                    if (self.security.supplier != nil) {
                        Text(self.security.supplier!)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(self.security.name)
                }
                
                Spacer()
                
                VStack {
                    Image(systemName: "arrowtriangle.up.fill")
                        .foregroundColor(.green)
                    Text(changePercentageString)
                        .foregroundColor(.green)
                        .font(.subheadline)
                }
            }
        }
    }
        
}
