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
    case AssetType = "Asset Type"
}

struct Classification: Identifiable {
    let id = UUID()
    var name: String
    let type: ClassificationType
    var parentID: UUID?
    var securities = Set<UUID>()
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
    Classification(name: "Risikobehafter Portfolioteil", type: .AssetAllocation, parentID: nil, securities: Set(arrayLiteral: securities[1].id)),
    Classification(name: "Risikoarmer Portfolioteil", type: .AssetAllocation, parentID: nil),
    Classification(name: "Kryptowährungen", type: .AssetAllocation, parentID: nil, securities: Set(arrayLiteral: securities[0].id))
]

let securities: [Security] = [
    Security(name: "ETH-EUR", symbol: "ETH-EUR"),
    Security(name: "MSCI Emerging Markets IMI UCITS", WKN: "A111X9", ISIN: "IE00BKM4GZ66", TER: 0.18, fee: 1.5, supplier: "iShares Core"),
    Security(name: "MSCI Emerging Markets IMI UCITS", WKN: "A111X9", ISIN: "IE00BKM4GZ66", TER: 0.18, fee: 1.5, supplier: "iShares Core")
]
#endif
