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
            Image(systemName: "arrow.uturn.forward")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(AppColors.settingsColor)
                .frame(width: 20, height: 20) // Set the desired size
                .padding(.bottom, 60)
                .bold()
            Text("Skip and")
                .foregroundColor(AppColors.cameraButtonColor)
                .font(.system(size: 16))
                .bold()
                .padding(.top, 20)
            Text("Process")
                .foregroundColor(AppColors.cameraButtonColor)
                .font(.system(size: 16))
                .bold()
                .padding(.top, 65)

        }
        .background(
            RoundedRectangle(cornerRadius: 50, style: .continuous)
                .stroke(AppColors.settingsColor, lineWidth: 5)
                .fill(AppColors.settingsColor)
                .frame(width: 180, height: 120)
                
        )
        .contentShape(RoundedRectangle(cornerRadius: 50))
        
        
            
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
            Text("Crop and Process")
                .foregroundColor(AppColors.cameraButtonColor)
                .font(.system(size: 16))
                .bold()
                .padding(.top, 20)
            Text("Image")
                .foregroundColor(AppColors.cameraButtonColor)
                .font(.system(size: 16))
                .bold()
                .padding(.top, 65)

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
    HStack {
        Spacer() // Adds spacing before the first button
        
        SkipCroppingButton()
            .frame(width: 180, height: 120) // Ensure both buttons have the same size
        Spacer(minLength: 20) // Add space between the buttons
        CropButton()
            .frame(width: 180, height: 120) // Ensure both buttons have the same size
        Spacer() // Adds spacing after the second button
    }
    .padding(.horizontal, 20) // Optional padding to prevent buttons from touching screen edges
}

