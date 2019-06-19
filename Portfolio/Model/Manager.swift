//
//  AccountManager.swift
//  Portfolio
//
//  Created by Nik Sauer on 07.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import Foundation

struct SecurityManager {
    
}

struct AccountManager {
    func createTransaction(_ transaction: AccountTransaction) {
        // increase/decrease balance
        // store transaction
    }
    
    func transfer(amount: Double, from: Account, to: Account) {}
    func buySecurity(_ security: Security, with account: Account) {}
    func sellSecurity(_ security: Security, from account: Account) {}
    //    func splitSecurity(_ security: Security, )
}

struct DepotManager {
    
}

