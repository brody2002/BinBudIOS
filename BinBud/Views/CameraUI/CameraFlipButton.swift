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
            .frame(width: pressFlipCamera ? 60: 50, height: pressFlipCamera ? 60: 50)
            .foregroundColor(AppColors.cameraButtonColor)
            .onTapGesture {
                self.pressFlipCamera.toggle()
            }
    }
}

#Preview {
    CameraFlipButton()
}
