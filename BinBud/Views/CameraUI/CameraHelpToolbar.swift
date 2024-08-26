//
//  CameraHelpToolbar.swift
//  BinBud
//
//  Created by Brody on 8/26/24.
//

import SwiftUI

struct CameraHelpToolbar: View {
    @Binding var showMenu : Bool
    var body: some View {
           
            ZStack{
                Color(AppColors.settingsColor.opacity(  0.3))
                    
                    .ignoresSafeArea()
                VStack{
                    ZStack{
                        Text("How to Use")
                            .font(.title)
                            .bold()
                            .foregroundColor(AppColors.settingsColor)
                        HStack{
                            Spacer()
                            Button(action: {
                                self.showMenu.toggle()
                            }, label: {
                                CameraHelpBackButton(showMenu: $showMenu)
                            })
                            
                                .padding(.trailing, 30)
                            
                            
                        }
                    }
                    
                    Spacer()
                    
                }
            
        }
        

        
           
    }
}

#Preview {
    ZStack{
        CameraHelpToolbar(showMenu: .constant(true))
    }

}
