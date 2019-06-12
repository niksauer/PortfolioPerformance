//
//  SecurityView.swift
//  Portfolio
//
//  Created by Nik Sauer on 08.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct SecurityView: View {
    var securities: [Security]
    
    var body: some View {
        List(self.securities) { security in
            NavigationButton(destination: SecurityDetailView(security: security)) {
                SecurityRow(security: security)
            }
        }
        .navigationBarTitle(Text("Securities"))
        .navigationBarItems(trailing: Button(action: createSecurity) { Image(systemName: "plus.circle") })
        .tabItemLabel(Text("Securities")) // Image(systemName: "list.bullet.below.rectangle")
    }
    
    private func createSecurity() {
        // show creation modal view
    }
}

//#if DEBUG
//struct SecurityView_Previews: PreviewProvider {
//    static var previews: some View {
//        SecurityView(securities: securities)
//    }
//}
//#endif


struct SecurityRow: View {
    let security: Security
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if (security.supplier != nil) {
                    Text(security.supplier!)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text(security.name)
            }
            
            Spacer()
            
            Image(systemName: "arrowtriangle.up.fill")
                .foregroundColor(.green)
        }
        
    }
}

struct SecurityDetailView: View {
    // MARK: - Properties
    let security: Security
    
    // MARK: - View
    var body: some View {
        Text(self.security.name)
    }
}
