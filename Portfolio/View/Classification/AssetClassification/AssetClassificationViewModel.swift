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
    var classificationTypes: Set<AssetClassificationType> { return assetStore.classificationTypes }
    
    // MARK: - Private Properties
    @ObjectBinding private var assetStore: AssetStore = .shared
    
    // MARK: - Private Properties
    init() {
        _ = assetStore.didChange.sink { assetStore in
            self.didChange.send(())
        }
    }
    
    // MARK: - Public Methods
    func getFlatClassificationHierarchy(type: AssetClassificationType) -> [AssetClassificationHierarchyObject] {
        let options = AssetClassificationHierarchyOptions(type: type, includeEntries: true, disableClassificationMovement: true, disableAssetMovement: false, disableClassificationDeletion: true, disableAssetDeletion: true)
        
        return assetStore.getFlatClassificationHierarchy(options: options)
    }
    
    func getFlatHierarchyObjectView(_ object: AssetClassificationHierarchyObject) -> AssetClassificationHierarchyObjectView {
        return AssetClassificationHierarchyObjectView(object: object)
    }
    
    func moveHierarchyObject(from source: IndexSet, to destination: Int, classificationType: ClassificationType) {
        // TODO: implement movement of classification
        assetStore.moveClassifiedObject(from: source, to: destination, classificationType: classificationType, showsEntries: true)
    }
    
    func deleteHierarchyObject(at: IndexSet, classificationType: ClassificationType) {
        // TODO: implement deletion of classification
    }
    
}
