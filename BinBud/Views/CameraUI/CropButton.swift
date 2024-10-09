//
//  CropButton.swift
//  BinBud
//
//  Created by Brody on 10/9/24.
//

import SwiftUI


struct SkipCroppingButton: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(AppColors.cameraButtonColor)
                .frame(width:34, height:34)
                .padding(.bottom,60)
            Image(systemName: "crop")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(AppColors.settingsColor)
                .frame(width: 24, height: 24) // Set the desired size
                .padding(.bottom, 60)
                .bold()
            Text("Skip Cropping")
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



struct CropButton: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(AppColors.cameraButtonColor)
                .frame(width:34, height:34)
                .padding(.bottom,60)
            Image(systemName: "crop")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(AppColors.settingsColor)
                .frame(width: 24, height: 24) // Set the desired size
                .padding(.bottom, 60)
                .bold()
            Text("Crop Image")
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
    SkipCroppingButton()
}
