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
    var classificationTypes: Set<AssetClassificationType> { return assetStore.classificationTypes }
    
    // MARK: - Private Properties
    private var assetStore: AssetStore = .shared
    
    // MARK: - Public Methods
    func getFlatClassificationHierarchy(type: AssetClassificationType) -> [AssetClassificationHierarchyObject] {
        let options = AssetClassificationHierarchyOptions(type: type, includeEntries: false, disableClassificationMovement: false, disableAssetMovement: true, disableClassificationDeletion: false, disableAssetDeletion: true)
        
        return assetStore.getFlatClassificationHierarchy(options: options)
    }
    
    func getFlatHierarchyObjectView(_ object: AssetClassificationHierarchyObject) -> AssetClassificationHierarchyObjectView {
        return AssetClassificationHierarchyObjectView(object: object)
    }
    
    func moveHierarchyObject(from: IndexSet, to: Int, classificationType: AssetClassificationType) {
        // TODO: implement movement of classification
    }
    
    func deleteHierarchyObject(at: IndexSet, classificationType: AssetClassificationType) {
        // TODO: implement deletion of classification
    }
    
}
