//
//  CameraSaveButton.swift
//  BinBud
//
//  Created by Brody on 8/23/24.
//

import SwiftUI

struct CameraSaveButton: View {
    
    
    var body: some View {
        Text("Use Image")
            .foregroundColor(AppColors.accentColor)
            .fontWeight(.semibold)
            .padding(.vertical, 10)
            .padding(.horizontal, 30)
            .background(AppColors.mainColor)
            .clipShape(Capsule())
    }
}

#Preview {
    CameraSaveButton()
}

