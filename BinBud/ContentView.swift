//
//  ContentView.swift
//  BinBud
//
//  Created by Brody on 8/23/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            ZStack{
                AppColors.mainColor.ignoresSafeArea()
                VStack {
                    Spacer()
                    Logo()
                    Spacer()
                    
                    NavigationLink(
                        destination: CameraView(),
                        label: {
                            BottomButton(str: "Go to Camera")
                        }) 
                }
            }
            .foregroundColor(AppColors.accentColor)
        }
    }
}

#Preview {
    ContentView()
}
