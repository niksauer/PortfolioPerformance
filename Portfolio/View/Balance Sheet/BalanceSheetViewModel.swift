//
//  BalanceSheetViewModel.swift
//  Portfolio
//
//  Created by Nik Sauer on 18.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class BalanceSheetViewModel: GroupedClassificationHierarchyViewModel {
    
    // MARK: - Types
    typealias ClassificationType = AssetClassificationType
    typealias ClassificationObject = Classification
    typealias HierarchyObject = AssetClassificationHierarchyObject
    typealias HierarchyObjectView = AnyView
    typealias ClassificationObjectView = BalanceSheetClassificationHeaderView
    
    // MARK: - Public Properties
    let didChange = PassthroughSubject<Void, Never>()
    
    var classificationType: AssetClassificationType = .AssetAllocation {
        didSet {
            didChange.send(())
        }
    }
    
    var classificationTypes: [AssetClassificationType] { return assetStore.classificationTypes }
    
    // MARK: - Private Properties
    @ObjectBinding private var assetStore: AssetStore = .shared
    
    private let hierarchyOptions = AssetClassificationHierarchyOptions(includeEntries: true, includeUnclassified: true, includeEmptyClassifications: false, disableClassificationMovement: true, disableAssetMovement: true, disableClassificationDeletion: true, disableAssetDeletion: true)
    
    // MARK: - Initilization
    init() {
        _ = assetStore.didChange.sink { assetStore in
            self.didChange.send(())
        }
    }
    
    // MARK: - Public Methods
    func getClassificationObjects(type: AssetClassificationType) -> [Classification] {
        return assetStore.getRootClassifications(type: type, options: hierarchyOptions)
    }

    func getFlatClassificationHierarchy(type: AssetClassificationType, classification: Classification) -> [AssetClassificationHierarchyObject] {
        return assetStore.getFlatClassificationHierarchy(type: type, classification: classification, options: hierarchyOptions)
    }
    
    func getHierarchyObjectView(_ object: AssetClassificationHierarchyObject) -> AnyView {
        switch object.wrappedObject {
        case let security as Security:
            return AnyView(SecurityRowView(security: security))
        case let account as Account:
            return AnyView(AccountRowView(account: account))
        default:
            fatalError()
        }
    }

    func getClassificationObjectView(_ classification: Classification) -> BalanceSheetClassificationHeaderView {
        return BalanceSheetClassificationHeaderView(classification: classification, totalAssetValue: 1023.4, totalShare: 32.1, currency: .EUR)
    }
    
}


