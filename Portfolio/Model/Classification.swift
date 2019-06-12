//
//  Classification.swift
//  Portfolio
//
//  Created by Nik Sauer on 12.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import Foundation
import SwiftUI

enum ClassificationType: Hashable {
    case AssetAllocation
    case Region
    case Industry
    case InvestmentType
    case SecurityType
    case Custom(name: String)
}

extension ClassificationType: RawRepresentable {
    typealias RawValue = String
    
    init?(rawValue: String) {
        switch rawValue {
        case "Asset Allokation":
            self = .AssetAllocation
        case "Region":
            self = .Region
        case "Industrie":
            self = .Industry
        case "Anlagekategorie":
            self = .InvestmentType
        case "Wertpapierart":
            self = .SecurityType
        default:
            self = .Custom(name: rawValue)
        }
    }
    
    var rawValue: String {
        switch self {
        case .AssetAllocation:
            return "Asset Allokation"
        case .Region:
            return "Region"
        case .Industry:
            return "Industrie"
        case .InvestmentType:
            return "Anlagekategorie"
        case .SecurityType:
            return "Wertpapierart"
        case .Custom(let name):
            return name
        }
    }
}

struct Classification: ClassificationOption {
    let id = UUID()
    let name: String
    let type: ClassificationType
    var parentID: UUID?
    var isCollapsed = false
    
    var category: String { return type.rawValue }
}

extension Classification: HierarchyObject {
    var title: String { return name }
    var subtitle: String? { return nil }
    var icon: Image { return Image(systemName: "folder.fill") }
    var isHierarchyEntry: Bool { return false }
}

protocol ClassificationOption: Identifiable {
    var category: String { get }
}

protocol Classifiable: Identifiable {
    
}

struct ClassificationAssignment<T: Classifiable, S: ClassificationOption> {
    let objectID: T.ID
    var classificationID: S.ID
    let type: String
    
    init(object: T, classification: S) {
        self.objectID = object.id
        self.classificationID = classification.id
        self.type = classification.category
    }
}
