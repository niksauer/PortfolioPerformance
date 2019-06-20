//
//  SecurityDetailView.swift
//  Portfolio
//
//  Created by Nik Sauer on 19.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct SecurityDetailView: View {
    
    // MARK: - Properties
    let security: Security
    
    // MARK: - View
    var body: some View {
        Text(self.security.name)
    }
    
}

//#if DEBUG
//struct SecurityDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        SecurityDetailView()
//    }
//}
//#endif
