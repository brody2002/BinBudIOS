//
//  CameraRetakeButton.swift
//  BinBud
//
//  Created by Brody on 8/23/24.
//

import SwiftUI

struct CameraRetakeButton: View {
    var body: some View {
        Image("RetakeIcon")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
    }
}

#Preview {
    CameraRetakeButton()
}
