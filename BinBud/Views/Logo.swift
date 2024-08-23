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
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let percentageOffset: CGFloat = 0.2 // This represents 20% of the screen width

            Image("BinBudLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 500, height: 500) // Adjust the size as needed
                .position(x: screenWidth * (0.456 + percentageOffset), y: geometry.size.height / 2)
        }
        .frame(height: 400)
    }
}

#Preview {
    ZStack{
        Color(red: 0/255, green: 206/255, blue: 137/255).ignoresSafeArea()
        Logo()
    }
}
