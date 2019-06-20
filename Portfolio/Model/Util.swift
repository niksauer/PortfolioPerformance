//
//  Util.swift
//  Portfolio
//
//  Created by Nik Sauer on 20.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import Foundation

func getNumberFormatter() -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.locale = Locale.current
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 2
    return formatter
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
