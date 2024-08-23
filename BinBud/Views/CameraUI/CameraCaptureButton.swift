//
//  CameraCaptureButton.swift
//  BinBud
//
//  Created by Brody on 8/23/24.
//

import SwiftUI

struct CameraCaptureButton: View {
    var body: some View {
        ZStack{
            Circle()
                .fill(AppColors.cameraButtonColor)
                .frame(width: 55,height: 55)
            Circle()
                .stroke(AppColors.cameraButtonColor, lineWidth: 2)
                .frame(width: 65,height: 65)
            Circle()
                .stroke(AppColors.cameraButtonColor, lineWidth: 1)
                .frame(width: 80,height: 80)
        }.frame(height: 80)
    }
}

#Preview {
    CameraCaptureButton()
}
