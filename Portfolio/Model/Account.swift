//
//  Account.swift
//  Portfolio
//
//  Created by Nik Sauer on 07.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import Foundation
import SwiftUI

enum Currency {
    case EUR
    case USD
}

struct Account: Identifiable {
    let id = UUID()
    var name: String
    var balance: Double
    var currency: Currency
}

#if DEBUG
let accounts: [Account] = [
    Account(name: "Comdirect Verrechnungskonto", balance: 999.8, currency: .EUR),
    Account(name: "Comdirect Tagesgeld PLUS", balance: 4035.39, currency: .EUR),
    Account(name: "Comdirect Girokonto", balance: 0, currency: .EUR)
]

let accountTransactions: [AccountTransaction] = [
    AccountTransaction(type: .Deposit, value: 1250, date: Date(), account: accounts[0].id),
    AccountTransaction(type: .Withdraw, value: -350, date: Date(), account: accounts[0].id)
]
#endif
