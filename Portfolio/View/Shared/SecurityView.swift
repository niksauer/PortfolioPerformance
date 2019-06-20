//
//  SecurityView.swift
//  Portfolio
//
//  Created by Nik Sauer on 08.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct SecurityView: View {
    
    // MARK: - Public Properties
    let security: Security
    let amount: Double? = 23.56
    let currentExchangeRate: Double = 223
    let prevousExchangeRate: Double = 220
    let currency: Currency = .EUR
    
    // MARK: - Private Properties
    private var value: Double? { return amount != nil ? amount! * currentExchangeRate : nil }
    private var changePercentage: Double { return (currentExchangeRate / prevousExchangeRate * 100) - 100 }
    
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
        let valueString = self.value != nil ? suffixNumber(self.value!) : "?"
        let exchangeRateString = self.numberFormatter.string(from: NSNumber(value: self.currentExchangeRate)) ?? "?"
        let changePercentageString = self.numberFormatter.string(from: NSNumber(value: self.changePercentage)) ?? "?"
        
        return HStack {
            if self.value != nil {
                VStack {
                    Text(valueString)
                        .font(.headline)
                    Text("\(exchangeRateString)\(self.currency.rawValue)")
                        .font(.subheadline)
                }
                .padding(.all, 15)
                .background(Color.gray, cornerRadius: 12)
                .foregroundColor(.white)
            }

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

func suffixNumber(_ number: Double) -> String {
    var number = number
    
    let sign = ((number < 0) ? "-" : "" );
    
    number = fabs(number);
    
    if (number < 1000.0){
        return "\(sign)\(number)";
    }
    
    let exp = Int(log10(number) / 3.0 ); //log10(1000));
    
    let units = ["K","M","G","T","P","E"];
    
    let roundedNum = round(10 * number / pow(1000.0,Double(exp))) / 10;
    
    return "\(sign)\(roundedNum)\(units[exp-1])";
}
