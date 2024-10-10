//
//  CameraSaveButton.swift
//  BinBud
//
//  Created by Brody on 8/23/24.
//

import SwiftUI
import SwiftUI

struct UseImageButton: View {
    
    var body: some View {

        
        
        ZStack {
            Image(systemName: "camera.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(AppColors.cameraButtonColor)
                .frame(width: 40, height: 40) // Set the desired size
                .padding(.bottom, 60)
            Text("Use Image")
                .foregroundColor(AppColors.cameraButtonColor)
                .font(.system(size: 16))
                .bold()
                .padding(.top, 20)

        }
        .background(
            RoundedRectangle(cornerRadius: 50, style: .continuous)
                .stroke(AppColors.settingsColor, lineWidth: 5)
                .fill(AppColors.settingsColor)
                .frame(width: 180, height: 120)
                
        )
        .contentShape(RoundedRectangle(cornerRadius: 50))
        // Gives button a hitbox
        
            
    
    }
}

#Preview {
    ZStack{
        Color.red
        UseImageButton()
    }
}
