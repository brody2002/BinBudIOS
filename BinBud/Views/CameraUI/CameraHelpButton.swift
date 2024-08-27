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
                .foregroundColor(AppColors.cameraButtonColor)
                .frame(width: 30, height: 30)
            Text("?")
                .foregroundColor(.black)
                .font(.system(size: 25))
                .bold()
                
        }
        
    }
}

#Preview {
    CameraHelpButton()
}
