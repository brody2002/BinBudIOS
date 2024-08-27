//
//  CameraRetakeButton.swift
//  BinBud
//
//  Created by Brody on 8/23/24.
//

import SwiftUI

struct CameraFlipButton: View {
    @State private var pressFlipCamera = false

    var body: some View {
        Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: pressFlipCamera ? 32: 30, height: pressFlipCamera ? 32: 30)
            .foregroundColor(AppColors.cameraButtonColor)
            .onTapGesture {
                self.pressFlipCamera.toggle()
            }
    }
}

#Preview {
    CameraFlipButton()
}
