//
//  CameraUnsaveButton.swift
//  BinBud
//
//  Created by Brody on 8/23/24.
//

//
//  CameraSaveButton.swift
//  BinBud
//
//  Created by Brody on 8/23/24.
//

import SwiftUI

struct CameraRetakeButton: View {
    
    
    var body: some View {
        ZStack {
            Image(systemName: "repeat.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(AppColors.cameraButtonColor)
                .frame(width: 35, height: 35) // Set the desired size
                .padding(.bottom, 60)
            Text("Retake Image")
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
        CameraRetakeButton()
    }
}


