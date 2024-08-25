//
//  CameraHelpButton.swift
//  BinBud
//
//  Created by Brody on 8/24/24.
//

import SwiftUI

struct CameraHelpButton: View {
    var body: some View {
        ZStack{
            Circle()
                .foregroundColor(AppColors.mainColor)
                .frame(width: 50, height: 50)
            Text("?")
                .foregroundColor(.black)
                .font(.system(size: 30))
                .bold()
                
        }
        
    }
}

#Preview {
    CameraHelpButton()
}
