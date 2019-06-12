//
//  Security.swift
//  Portfolio
//
//  Created by Nik Sauer on 07.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import Foundation
import SwiftUI

struct Security: Classifiable {
    let id = UUID()
    var name: String
    var WKN: String?
    var ISIN: String?
    var symbol: String?
    var TER: Double?
    var fee: Double?
    var supplier: String?
}

extension Security: HierarchyObject {
    var title: String { return name }
    var subtitle: String? { return supplier }
    var icon: Image { return Image(systemName: "s.square") }
    var isHierarchyEntry: Bool { return true }
}
