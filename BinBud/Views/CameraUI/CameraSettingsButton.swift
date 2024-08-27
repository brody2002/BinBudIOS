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
            Circle()
                .frame(width: 28, height: 28)
                .foregroundColor(AppColors.cameraButtonColor)
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
                .padding(.top,15)
        }
    }
}

#Preview {
    CameraSettingsButton()
}
