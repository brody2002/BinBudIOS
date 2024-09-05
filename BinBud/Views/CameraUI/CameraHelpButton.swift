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
            Image(systemName: "questionmark.circle.fill")
                .resizable()
                .frame(width: 26, height: 26)
                .foregroundColor(AppColors.cameraButtonColor)
            
            
                
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
