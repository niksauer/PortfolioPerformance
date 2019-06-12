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
