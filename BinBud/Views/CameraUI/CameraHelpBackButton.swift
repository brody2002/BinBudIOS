//
//  CameraHelpButton.swift
//  BinBud
//
//  Created by Brody on 8/24/24.
//

import SwiftUI

struct CameraHelpBackButton: View {
    
    @Binding var showHelpMenu: Bool
    
    var body: some View {
        ZStack{
            Image(systemName: "chevron.backward.circle.fill")
                .resizable()
                .frame(width: 35, height: 35)
                .foregroundColor(.white)
                .rotationEffect(.degrees(-90))
                .onTapGesture {
                    print("tapped help back")
                    withAnimation(.spring(response: 0.3, blendDuration: 0.9)) {
//                      
                        self.showHelpMenu = false
                        
                    }
                }
                
        }

        
    }
}

#Preview {
    ZStack{
        Color.red
        CameraHelpBackButton(showHelpMenu: .constant(false))
    }
    
}
