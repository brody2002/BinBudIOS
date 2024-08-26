//
//  CameraHelpButton.swift
//  BinBud
//
//  Created by Brody on 8/24/24.
//

import SwiftUI

struct CameraHelpBackButton: View {
    @Binding var showMenu: Bool
    
    var body: some View {
        ZStack{
            Circle()
                .stroke(AppColors.settingsColor, lineWidth: 8)
                .frame(width: 50,height: 50)
            Text("X")
                .foregroundColor(AppColors.settingsColor)
                .font(.system(size: 30))
                .bold()
                
        }
        .onTapGesture {
                    showMenu.toggle() // Toggle the showMenu state
                }
        
    }
}

#Preview {
    CameraHelpBackButton(showMenu: .constant(false))
}
