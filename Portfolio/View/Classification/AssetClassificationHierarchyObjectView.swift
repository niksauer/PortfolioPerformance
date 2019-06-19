//
//  AssetClassificationHierarchyObjectView.swift
//  Portfolio
//
//  Created by Nik Sauer on 19.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct AssetClassificationHierarchyObjectView: View {
    
    // MARK: - Public Properties
//    let object: AssetClassificationHierarchyObject
    let title: String
    let subtitle: String?
    let icon: Image
    
    // MARK: - View
    var body: some View {
        HStack {
            self.icon
            
            VStack(alignment: .leading) {
                if (self.subtitle != nil) {
                    Text(self.subtitle!)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text(self.title)
            }
            .padding(.leading, Length(integerLiteral: 8))
        }
    }
    
}

//#if DEBUG
//struct AssetClassificationHierarchyObjectView_Previews : PreviewProvider {
//    static var previews: some View {
//        AssetClassificationHierarchyObjectView()
//    }
//}
//#endif
