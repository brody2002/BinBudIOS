//
//  BottomButton.swift
//  BinBud
//
//  Created by Brody on 8/23/24.
//

import SwiftUI
import Foundation

struct BottomButton: View {
    let str: String
    
    var body: some View {
        
        HStack {
            Spacer()
            Text(str)
                .font(.title)
                .bold()
                .padding()
                .foregroundColor(AppColors.mainColor)
            Spacer()
        }.background(AppColors.accentColor)
            
    }
}


#Preview {
    ZStack{
        Color.gray.ignoresSafeArea()
        BottomButton(str: "Identify Trash")
    }
}
