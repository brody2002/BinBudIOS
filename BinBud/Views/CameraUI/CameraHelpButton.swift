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
            
                
        }.background(
            Rectangle()
                .fill(Color.clear) // Invisible background
                .frame(width: 80, height: 80) // Adjust size to expand the touch area
        )
        
    }
}

#Preview {
    CameraHelpButton()
}
