//
//  CameraRetakeButton.swift
//  BinBud
//
//  Created by Brody on 8/23/24.
//

import SwiftUI

struct CameraFlipButton: View {
    

    var body: some View {
        Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            .foregroundColor(AppColors.cameraButtonColor)
            .background(
                Rectangle()
                    .fill(Color.clear) // Invisible background
                    .frame(width: 80, height: 80) // Adjust size to expand the touch area
            )
            
    }
}

#Preview {
    CameraFlipButton()
}
