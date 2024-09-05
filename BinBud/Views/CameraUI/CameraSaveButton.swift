//
//  CameraSaveButton.swift
//  BinBud
//
//  Created by Brody on 8/23/24.
//

import SwiftUI

struct CameraSaveButton: View {
    
    
    var body: some View {
        ZStack {
            Image(systemName: "camera.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(AppColors.cameraButtonColor)
                .frame(width: 40, height: 40) // Set the desired size
                .padding(.bottom, 60)
            Text("Use Image")
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
    CameraSaveButton()
}

