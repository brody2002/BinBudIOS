//
//  SettingsToolBar.swift
//  BinBud
//
//  Created by Brody on 8/27/24.
//

import SwiftUI

struct CameraSettingsButton: View {
    var body: some View {
            ZStack{
                // Your existing button design
                RoundedRectangle(cornerRadius: 60, style: .continuous)
                    .fill(AppColors.cameraButtonColor)
                    .frame(width: 26, height: 2)
                    .padding(.bottom, 15)
                RoundedRectangle(cornerRadius: 60, style: .continuous)
                    .fill(AppColors.cameraButtonColor)
                    .frame(width: 26, height: 2)
                RoundedRectangle(cornerRadius: 60, style: .continuous)
                    .fill(AppColors.cameraButtonColor)
                    .frame(width: 26, height: 2)
                    .padding(.top, 15)
            }
            .background(
                Rectangle()
                    .fill(Color.clear) // Invisible background
                    .frame(width: 50, height: 50) // Adjust size to expand the touch area
            )
            .contentShape(Rectangle()) // Makes the entire background tappable
        }
}

#Preview {
    CameraSettingsButton()
}
