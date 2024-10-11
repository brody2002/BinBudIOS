//
//  BinBudApp.swift
//  BinBud
//
//  Created by Brody on 8/23/24.
//
import SwiftUI

@main
struct BinBudApp: App {
    @StateObject var camera = CameraModel() // Ensure camera model is a state object
    @State private var cameraReady = false  // State to track when camera is ready
    @State var checkPermissions: Bool = false
    var body: some Scene {
        WindowGroup {
            ZStack {
                if cameraReady {
                    CameraView(hideCameraUI: false, camera: camera, checkPermissions: .constant(checkPermissions))
//                        .onAppear{
//                            print(checkPermissions)
//                            if checkPermissions{
//                                camera.check()
//                            }
//                        }
                    
                         
                        
                } else {
                    // Launch screen content
                    Image("Background")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                    
                    Logo()
                        .padding(.bottom, 400)
                        .padding(.trailing, -1)
                        .transition(.opacity)
                        .zIndex(0)
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.9), value: cameraReady)
            .onAppear {
                print("checking camera")
                camera.check()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                    cameraReady = true
                }
            }
        }
    }
}
