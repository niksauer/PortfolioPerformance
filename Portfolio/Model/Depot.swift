//
//  Depot.swift
//  Portfolio
//
//  Created by Nik Sauer on 07.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import Foundation
import SwiftUI

struct Depot: Identifiable {
    let id = UUID()
    var name: String
    let account: UUID
}

enum Frequency {
    case Week(Int)
    case Month(Int)
}

struct SavingsPlan: Identifiable {
    let id = UUID()
    var name: String
    let depot: UUID
    let security: UUID
    let startDate: Date
    var frequency: Frequency
    var value: Double
    var fee: Double
}

#if DEBUG
let depots: [Depot] = [
    Depot(name: "Weltportfolio", account: accounts[0].id),
    Depot(name: "Ledger Nano S", account: accounts[0].id)
]

let savingPlans: [SavingsPlan] = [
    SavingsPlan(name: "FTSE EPRA/NAREIT Global Developed", depot: depots[0].id, security: securities[1].id, startDate: Date(), frequency: .Month(1), value: 100, fee: 0)
]

let depotTransactions: [DepotTransaction] = [
    DepotTransaction(type: .SecurityPurchase, date: Date(), deposit: depots[0].id, security: securities[1].id, savingsPlan: nil, amount: 9.388, exchangeRate: 23.609, fee: 3.37, tax: 0)
]
#endif
