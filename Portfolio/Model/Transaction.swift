//
//  Transaction.swift
//  Portfolio
//
//  Created by Nik Sauer on 07.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import Foundation
import SwiftUI

enum TransactionType {
    case Deposit
    case Withdraw
    case InterestCredit
    case InterestFee
    case Fee
    case FeeReimbursement
    case Tax
    case TaxCredit
    case SecurityPurchase
    case SecuritySale
    case SecurityImport
    case SecurityExport
    case Dividend
}

protocol Transaction: Identifiable {
    var id: UUID { get }
    var type: TransactionType { get }
    var value: Double { get }
    var date: Date { get }
}

struct AccountTransaction: Transaction {
    let id = UUID()
    let type: TransactionType
    let value: Double
    let date: Date
    
    let account: UUID
}

struct DepotTransaction: Transaction {
    let id = UUID()
    let type: TransactionType
    var value: Double { return amount * exchangeRate }
    let date: Date
    
    let deposit: UUID
    let security: UUID
    let savingsPlan: UUID?
    
    let amount: Double
    let exchangeRate: Double
    let fee: Double
    let tax: Double
    var valueBeforeTaxAndFee: Double { return amount * exchangeRate }
}
