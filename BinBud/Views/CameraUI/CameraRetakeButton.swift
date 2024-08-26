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
        Text("Retake Photo")
            .foregroundColor(.black)
            .fontWeight(.semibold)
            .padding(.vertical, 10)
            .padding(.horizontal, 30)
            .background(AppColors.unsave)
            .clipShape(Capsule())
    }
}

#Preview {
    CameraRetakeButton()
}


