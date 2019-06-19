//
//  ClassifiedObjectsViewModel.swift
//  Portfolio
//
//  Created by Nik Sauer on 16.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class AssetClassificationViewModel: ClassificationHierarchyViewModel {

    // MARK: - Types
    typealias ClassificationType = AssetClassificationType
    typealias FlatHierarchyObjectModel = AssetClassificationHierarchyObject
    typealias FlatHierarchyObjectView = AssetClassificationHierarchyObjectView
    
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
    
    private let hierarchyOptions = AssetClassificationHierarchyOptions(includeEntries: true, includeUnclassified: true, includeEmptyClassifications: true, disableClassificationMovement: true, disableAssetMovement: false, disableClassificationDeletion: true, disableAssetDeletion: true)
    
    // MARK: - Private Properties
    init() {
        _ = assetStore.didChange.sink { assetStore in
            self.didChange.send(())
        }
    }
    
    // MARK: - Public Methods
    func getFlatClassificationHierarchy(type: AssetClassificationType) -> [AssetClassificationHierarchyObject] {
        return assetStore.getFlatClassificationHierarchy(type: type, options: hierarchyOptions)
    }
    
    func getFlatHierarchyObjectView(_ object: AssetClassificationHierarchyObject) -> AssetClassificationHierarchyObjectView {
        switch object.wrappedObject {
        case let classification as Classification:
            return AssetClassificationHierarchyObjectView(title: classification.name, subtitle: nil, icon: classification.icon)
        case let security as Security:
            return AssetClassificationHierarchyObjectView(title: security.name, subtitle: security.supplier, icon: security.icon)
        case let account as Account:
            return AssetClassificationHierarchyObjectView(title: account.name, subtitle: nil, icon: account.icon)
        default:
            fatalError()
        }
    }
    
    func moveHierarchyObject(from source: IndexSet, to destination: Int) {
        // TODO: implement movement of classification
        assetStore.moveClassifiedObject(from: source, to: destination, classificationType: classificationType, hierarchyOptions: hierarchyOptions)
    }
    
    func deleteHierarchyObject(at: IndexSet) {
        // TODO: implement deletion of classification
    }
    
}
