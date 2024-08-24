//
//  ContentView.swift
//  BinBud
//
//  Created by Brody on 8/23/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var camera = CameraModel()
    var body: some View {
        NavigationView{
            ZStack{
                Image("MindBlowing_design")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Logo()
                    Spacer()
                    
                    NavigationLink(
                        destination: CameraView(camera: camera),
                        label: {
                            BottomButton(str: "Go to Camera")
                        }
                    )
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            
                            camera.check()
                            
                        }
                    )
                }
            }
            .foregroundColor(AppColors.accentColor)
        }
    }
}

#Preview {
    ContentView()
}
