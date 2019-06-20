//
//  SecurityListViewModel.swift
//  Portfolio
//
//  Created by Nik Sauer on 19.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class SecurityListViewModel: BindableObject {
    
    // MARK: - Public Properties
    let didChange = PassthroughSubject<Void, Never>()
    var securities: [Security] { return assetStore.securities }
    
    // MARK: - Private Properties
    @ObjectBinding private var assetStore: AssetStore = .shared
    
    // MARK: - Initilization
    
    // MARK: - Public Methods

    
}
