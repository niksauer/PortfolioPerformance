//
//  SecurityListView.swift
//  Portfolio
//
//  Created by Nik Sauer on 19.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct SecurityListView: View {
    
    // MARK: - Public Properties
    @ObjectBinding var viewModel: SecurityListViewModel
    
    // MARK: - Private Properties
    
    // MARK: - View
    var body: some View {
        List(self.viewModel.securities) { security in
            SecurityRowView(security: security)
        }
        .navigationBarTitle(Text("Wertpapiere"))
        .navigationBarItems(trailing: Button(action: createSecurity) { Image(systemName: "plus.circle") })
        .tabItemLabel(Text("Securities")) // Image(systemName: "list.bullet.below.rectangle")
    }
    
    // MARK: - Private Methods
    private func createSecurity() {
        // show creation modal view
    }
}

#if DEBUG
struct SecurityListView_Previews: PreviewProvider {
    static let viewModel = SecurityListViewModel()
    
    static var previews: some View {
        SecurityListView(viewModel: viewModel)
    }
}
#endif
