//
//  Logo.swift
//  BinBud
//
//  Created by Brody on 8/23/24.
//

import Foundation
import SwiftUI

struct Logo: View {
    
    var body: some View {
        

            Image("BinBud-Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 240, height: 128) // Adjust the size as needed
                
        
    }
}

#Preview {
    ZStack{
        Color(red: 0/255, green: 206/255, blue: 137/255).ignoresSafeArea()
        Logo()
            .padding(.bottom,550)
    }
    
        
}
