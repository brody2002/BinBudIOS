//
//  ContentView.swift
//  BinBud
//
//  Created by Brody on 8/23/24.
//

//
//  ContentView.swift
//  BinBud
//
//  Created by Brody on 8/23/24.
//

import SwiftUI

struct ContentView: View {
    @State var camera = CameraModel()
    var body: some View {
        NavigationView{
            ZStack{
                Image("Background")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .edgesIgnoringSafeArea(.all)
                                
                VStack {
                    Spacer()
                    Logo()
                        .padding(.bottom,450)
                        .padding(.trailing, 0)
                    Spacer()
                   
                }
            }
            .foregroundColor(AppColors.accentColor)
        }
    }
}

#Preview {
    ContentView()
}
