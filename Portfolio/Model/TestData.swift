//
//  TestData.swift
//  Portfolio
//
//  Created by Nik Sauer on 12.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import Foundation

struct TestData {
    
    // MARK: Public Properties
    let securities: [Security]
    
    let accounts: [Account]
//    let accountTransactions: [AccountTransaction]
    
    let classifications: [Classification]
    let securityClassifications: [ClassificationAssignment<Security, Classification>]
    let accountClassifications: [ClassificationAssignment<Account, Classification>]
    
    let depots: [Depot]
    let depotTransactions: [DepotTransaction]
    let savingPlans: [SavingsPlan]
    
    // MARK: Initialization
    init() {
        // securities
        var securities = [Security]()
        
        let etherSecurity = Security(name: "ETH-EUR", symbol: "ETH-EUR")
        let emergingMarketsSecurity = Security(name: "MSCI Emerging Markets IMI", WKN: "A111X9", ISIN: "IE00BKM4GZ66", TER: 0.18, fee: 1.5, supplier: "iShares Core")
        let worldSecurity = Security(name: "MSCI World UCITS ETF - EUR (D)", WKN: "A2H9QY", ISIN: "LU1737652237", TER: 0.18, fee: 0, supplier: "Amundi")
        let worldSmallCapSecurity = Security(name: "MSCI World Small Cap", WKN: "A2DWBY", ISIN: "IE00BF4RFH31", TER: 0.35, fee: 1.5, supplier: "iShares")
        let realEstateSecurity = Security(name: "FTSE EPRA/NAREIT Global Developed", WKN: "LYX0Y2", ISIN: "LU1832418773", TER: 0.45, fee: 0, supplier: "Lyxor")
        
        securities.append(contentsOf: [etherSecurity, emergingMarketsSecurity, worldSecurity, worldSmallCapSecurity, realEstateSecurity])
        self.securities = securities
        
        // accounts
        var accounts = [Account]()
        
        let depotAccount = Account(name: "Comdirect Verrechnungskonto", balance: 999.8, currency: .EUR)
        let savingsAccount = Account(name: "Comdirect Tagesgeld PLUS", balance: 4035.39, currency: .EUR)
        let bankAccount = Account(name: "Comdirect Girokonto", balance: 0, currency: .EUR)
        
        accounts.append(contentsOf: [depotAccount, savingsAccount, bankAccount])
        self.accounts = accounts
        
        // classifications
        var classifications = [Classification]()
        
            // asset allocation
        let noAssetAllocation = Classification(name: "Ohne Klassifizierung", type: .AssetAllocation)
                // level 0
        let riskfulClassification = Classification(name: "Risikobehafter Portfolioteil", type: .AssetAllocation)
        let risklessClassification = Classification(name: "Risikoarmer Portfolioteil", type: .AssetAllocation)
        let cryptoClassification = Classification(name: "Kryptowährungen", type: .AssetAllocation)
                // level 1
        let stockClassification = Classification(name: "Aktien", type: .AssetAllocation, parentID: riskfulClassification.id)
        let realEstateClassification = Classification(name: "Immobilien", type: .AssetAllocation, parentID: riskfulClassification.id)
        let commodityClassification = Classification(name: "Rohstoffe", type: .AssetAllocation, parentID: riskfulClassification.id)
        
                // level 2
        let developedCountriesClassification = Classification(name: "Aktien Industrieländer", type: .AssetAllocation, parentID: stockClassification.id)
        let emergingCountriesClassification = Classification(name: "Aktien Schwellenländer", type: .AssetAllocation, parentID: stockClassification.id)
        
        classifications.append(contentsOf: [riskfulClassification, risklessClassification, cryptoClassification, stockClassification, realEstateClassification, commodityClassification, developedCountriesClassification, emergingCountriesClassification, noAssetAllocation])
        
            // investment type
        let noInvestmentType = Classification(name: "Ohne Klassifizierung", type: .InvestmentType)
                // level 0
        let cashResourcesClassification = Classification(name: "Barvermögen", type: .InvestmentType)
        let equityCapitalClassification = Classification(name: "Eigenkapital", type: .InvestmentType)
        let outsideCapitalClassification = Classification(name: "Fremdkapital", type: .InvestmentType)
        let realEasteInvestmentClassification = Classification(name: "Immobilien", type: .InvestmentType)
        let commodityInvestmentClassification = Classification(name: "Rohstoffe", type: .InvestmentType)
        
        classifications.append(contentsOf: [cashResourcesClassification, equityCapitalClassification, outsideCapitalClassification, realEasteInvestmentClassification, commodityInvestmentClassification, noInvestmentType])
        
        self.classifications = classifications
        
        // security classification
        var securityClassifications = [ClassificationAssignment<Security, Classification>]()
            // asset allocation
        securityClassifications.append(ClassificationAssignment<Security, Classification>(object: etherSecurity, classification: cryptoClassification))
        securityClassifications.append(ClassificationAssignment<Security, Classification>(object: worldSecurity, classification: developedCountriesClassification))
        
        securityClassifications.append(ClassificationAssignment<Security, Classification>(object: emergingMarketsSecurity, classification: noAssetAllocation))
        securityClassifications.append(ClassificationAssignment<Security, Classification>(object: worldSmallCapSecurity, classification: noAssetAllocation))
        securityClassifications.append(ClassificationAssignment<Security, Classification>(object: realEstateSecurity, classification: noAssetAllocation))
        
            // investment type
        securityClassifications.append(ClassificationAssignment<Security, Classification>(object: etherSecurity, classification: noInvestmentType))
        securityClassifications.append(ClassificationAssignment<Security, Classification>(object: worldSecurity, classification: noInvestmentType))
        securityClassifications.append(ClassificationAssignment<Security, Classification>(object: worldSmallCapSecurity, classification: noInvestmentType))
        securityClassifications.append(ClassificationAssignment<Security, Classification>(object: emergingMarketsSecurity, classification: noInvestmentType))
        securityClassifications.append(ClassificationAssignment<Security, Classification>(object: realEstateSecurity, classification: realEasteInvestmentClassification))
        
        self.securityClassifications = securityClassifications
        
        // account classification
        var accountClassifications = [ClassificationAssignment<Account, Classification>]()
            // asset allocation
        accountClassifications.append(ClassificationAssignment<Account, Classification>(object: depotAccount, classification: risklessClassification))
        accountClassifications.append(ClassificationAssignment<Account, Classification>(object: savingsAccount, classification: risklessClassification))
        accountClassifications.append(ClassificationAssignment<Account, Classification>(object: bankAccount, classification: risklessClassification))
        
            // investment type
        accountClassifications.append(ClassificationAssignment<Account, Classification>(object: depotAccount, classification: cashResourcesClassification))
        accountClassifications.append(ClassificationAssignment<Account, Classification>(object: savingsAccount, classification: cashResourcesClassification))
        accountClassifications.append(ClassificationAssignment<Account, Classification>(object: bankAccount, classification: cashResourcesClassification))
        
        self.accountClassifications = accountClassifications
        
        // depots
        var depots = [Depot]()
        let worldDepot = Depot(name: "Weltportfolio", account: accounts[0].id)
        let cryptoDepot = Depot(name: "Ledger Nano S", account: accounts[0].id)
        depots.append(contentsOf: [worldDepot, cryptoDepot])
        self.depots = depots
        
        // saving plans
        var savingPlans = [SavingsPlan]()
        savingPlans.append(SavingsPlan(name: "FTSE EPRA/NAREIT Global Developed", depot: depots[0].id, security: securities[1].id, startDate: Date(), frequency: .Month(1), value: 100, fee: 0))
        self.savingPlans = savingPlans
        
        // account transactions
        var accountTransactions = [AccountTransaction]()
        accountTransactions.append(AccountTransaction(type: .Deposit, value: 1250, date: Date(), account: accounts[0].id))
        accountTransactions.append(AccountTransaction(type: .Withdraw, value: -350, date: Date(), account: accounts[0].id))
        
        // depot transactions
        var depotTransactions = [DepotTransaction]()
        depotTransactions.append(DepotTransaction(type: .SecurityPurchase, date: Date(), deposit: depots[0].id, security: securities[1].id, savingsPlan: nil, amount: 9.388, exchangeRate: 23.609, fee: 3.37, tax: 0))
        self.depotTransactions = depotTransactions
    }
}

// securities[2].id > aktien industrieländer
// securities[1].id > aktien schwellenländer
