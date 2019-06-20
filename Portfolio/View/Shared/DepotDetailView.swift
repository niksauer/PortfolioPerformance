//
//  DepotDetailView.swift
//  Portfolio
//
//  Created by Nik Sauer on 20.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct DepotDetailView: View {
    let depot: Depot
    
    var body: some View {
        HStack {
            Text(self.depot.name)
        }
    }
}

//#if DEBUG
//struct DepotDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DepotDetailView()
//    }
//}
//#endif
