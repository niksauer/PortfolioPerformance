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

class BalanceSheetViewModel: ClassificationHierarchyViewModel {

    // MARK: - Types
    typealias ClassificationType = AssetClassificationType
    typealias FlatHierarchyObjectModel = AssetClassificationHierarchyObject
    typealias FlatHierarchyObjectView = AnyView
    
    // MARK: - Public Properties
    let didChange = PassthroughSubject<Void, Never>()
    
    var classificationType: AssetClassificationType = .AssetAllocation {
        didSet {
            didChange.send(())
        }
    }
    
    var classificationTypes: Set<AssetClassificationType> { return assetStore.classificationTypes }
    
    // MARK: - Private Properties
    @ObjectBinding private var assetStore: AssetStore = .shared
    
    private let options = AssetClassificationHierarchyOptions(includeEntries: true, includeUnclassified: false, includeEmptyClassifications: false, disableClassificationMovement: true, disableAssetMovement: true, disableClassificationDeletion: true, disableAssetDeletion: true)
    
    // MARK: - Private Properties
    init() {
        _ = assetStore.didChange.sink { assetStore in
            self.didChange.send(())
        }
    }
    
    // MARK: - Public Methods
    func getFlatClassificationHierarchy(type: AssetClassificationType) -> [AssetClassificationHierarchyObject] {
        return assetStore.getFlatRootClassificationHierarchy(type: type, options: options)
    }
    
    func getFlatHierarchyObjectView(_ object: AssetClassificationHierarchyObject) -> AnyView {
        switch object.wrappedObject {
        case let classification as Classification:
            return AnyView(ClassificationRow(classification: classification))
        case let security as Security:
            return AnyView(SecurityRow(security: security))
        case let account as Account:
            return AnyView(AccountRow(account: account))
        default:
            fatalError()
        }
    }
    
}


struct ClassificationRow: View {
    let classification: Classification
    
    var body: some View {
        Text("hello")
    }
}
