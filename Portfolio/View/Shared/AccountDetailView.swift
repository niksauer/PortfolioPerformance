//
//  AccountDetailView.swift
//  Portfolio
//
//  Created by Nik Sauer on 20.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct AccountDetailView: View {
    let account: Account
    
    var body: some View {
        HStack {
            Text(self.account.name)
        }
    }
}

//#if DEBUG
//struct AccountDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccountDetailView()
//    }
//}
//#endif
