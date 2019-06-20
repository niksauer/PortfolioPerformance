//
//  ClassificationView.swift
//  Portfolio
//
//  Created by Nik Sauer on 19.06.19.
//  Copyright © 2019 SauerStudios. All rights reserved.
//

import SwiftUI

struct ClassificationView: View {
    let classification: Classification
    
    var body: some View {
        HStack {
            self.classification.icon
            
            Text(self.classification.name)
                .padding(.leading, Length(integerLiteral: 8))
        }
    }
}

//#if DEBUG
//struct ClassificationView_Previews : PreviewProvider {
//    static var previews: some View {
//        ClassificationRow()
//    }
//}
//#endif
