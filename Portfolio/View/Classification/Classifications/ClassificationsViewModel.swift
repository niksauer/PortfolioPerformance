//
//  ClassificationsViewModel.swift
//  Portfolio
//
//  Created by Nik Sauer on 16.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class ClassificationsViewModel: ClassificationHierarchyViewModel {
    
    // MARK: - Types
    typealias ClassificationType = AssetClassificationType
    typealias FlatHierarchyObject = AssetClassificationHierarchyObject
    typealias FlatHierarchyObjectView = AssetClassificationHierarchyObjectView
    
    // MARK: - Public Properties    
    let didChange = PassthroughSubject<Void, Never>()
    
    var classificationType: AssetClassificationType {
        didSet {
            didChange.send(())
        }
    }
    
    var classificationTypes: Set<AssetClassificationType> { return assetStore.classificationTypes }
    
    // MARK: - Private Properties
    private var assetStore: AssetStore = .shared
    
    private let hierarchyOptions = AssetClassificationHierarchyOptions(includeEntries: false, includeUnclassified: false, includeEmptyClassifications: true, disableClassificationMovement: false, disableAssetMovement: true, disableClassificationDeletion: false, disableAssetDeletion: true)
    
    init(classificationType: ClassificationType) {
        self.classificationType = classificationType
    }
    
    // MARK: - Public Methods
    func getFlatClassificationHierarchy(type: AssetClassificationType) -> [AssetClassificationHierarchyObject] {
        return assetStore.getFlatClassificationHierarchy(type: type, options: hierarchyOptions)
    }
    
    func getFlatHierarchyObjectView(_ object: AssetClassificationHierarchyObject) -> AssetClassificationHierarchyObjectView {
        return AssetClassificationHierarchyObjectView(object: object)
    }
    
    func moveHierarchyObject(from: IndexSet, to: Int) {
        // TODO: implement movement of classification
    }
    
    func deleteHierarchyObject(at: IndexSet) {
        // TODO: implement deletion of classification
    }
    
}
