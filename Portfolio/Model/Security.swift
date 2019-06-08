//
//  Security.swift
//  Portfolio
//
//  Created by Nik Sauer on 07.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import Foundation
import SwiftUI

enum ClassificationOption {
    case None
    case Custom(classification: Classification)
}

enum ClassificationType: String {
    case AssetAllocation = "Asset Allocation"
    case Region = "Region"
    case Industry = "Industry"
    case InvestmentType = "Investment Type"
    case SecurityType = "Security Type"
}

struct Classification: Identifiable {
    let id = UUID()
    var name: String
    let type: ClassificationType
    var parentID: UUID?
    var associatedObjects = Set<UUID>()
    var isCollapsed = false
}

struct Security: Identifiable {
    let id = UUID()
    var name: String
    var WKN: String?
    var ISIN: String?
    var symbol: String?
    var TER: Double?
    var fee: Double?
    var supplier: String?
}

#if DEBUG
let classifications: [Classification] = [
    // asset allocation
    Classification(name: "Risikobehafter Portfolioteil", type: .AssetAllocation),
    Classification(name: "Risikoarmer Portfolioteil", type: .AssetAllocation, associatedObjects: Set(accounts.map({ $0.id }))),
    Classification(name: "Kryptowährungen", type: .AssetAllocation, associatedObjects: Set(arrayLiteral: securities[0].id)),
    
    Classification(name: "Ohne Klassifikation", type: .AssetAllocation),
    
    // investment type
    Classification(name: "Barvermögen", type: .InvestmentType, associatedObjects: Set(accounts.map({ $0.id })))
]

let securities: [Security] = [
    Security(name: "ETH-EUR", symbol: "ETH-EUR"),
    Security(name: "MSCI Emerging Markets IMI UCITS", WKN: "A111X9", ISIN: "IE00BKM4GZ66", TER: 0.18, fee: 1.5, supplier: "iShares Core"),
    Security(name: "MSCI World UCITS ETF - EUR (D)", WKN: "A2H9QY", ISIN: "LU1737652237", TER: 0.18, fee: 0, supplier: "Amundi")
]
#endif
