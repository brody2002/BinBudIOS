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
                .foregroundColor(.white)
                .font(.system(size: 16))
                .bold()
                .padding(.top, 20)

        }
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(AppColors.settingsColor)
                .frame(width: 120, height: 120)
                
        )
            
    }
}

#Preview {
    CameraRetakeButton()
}


