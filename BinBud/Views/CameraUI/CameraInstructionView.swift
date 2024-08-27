//
//  CameraInstructionsView.swift
//  BinBud
//
//  Created by Brody on 8/27/24.
//

import SwiftUI

struct CameraInstructionView: View {
    var body: some View {
        HStack{
            Text("Take a picture of a piece of trash")
                .foregroundColor(.white)
                .font(.system(size: 13))
                .bold()
                
            

        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 60, style: .continuous)
                .fill(AppColors.settingsColor)
                .frame(width: 230, height: 26)
        )
        
        
    }
}

#Preview {
    CameraInstructionView()
}


