//
//  Account.swift
//  Portfolio
//
//  Created by Nik Sauer on 07.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import Foundation
import SwiftUI

enum Currency: String {
    case EUR = "€"
    case USD = "$"
}

struct Account: Classifiable {
    let id = UUID()
    var name: String
    var balance: Double
    var currency: Currency
}

extension Account: AssetClassificationHierarchyObjectModel {
    var title: String { return name }
//    var subtitle: String? { return nil }
    var icon: Image { return Image(systemName: "a.square") }
    var isHierarchyEntry: Bool { return true }
}
