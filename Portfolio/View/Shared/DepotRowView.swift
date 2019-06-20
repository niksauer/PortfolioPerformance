//
//  DepotRowView.swift
//  Portfolio
//
//  Created by Nik Sauer on 08.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct DepotRowView: View {
    let depot: Depot
    
    var body: some View {
        HStack {
            Text(self.depot.name)
        }
    }
}

//#if DEBUG
//struct DepotRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        DepotView(depots: depots)
//    }
//}
//#endif
