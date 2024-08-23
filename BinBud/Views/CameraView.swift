//
//  CameraView.swift
//  BinBud
//
//  Created by Brody on 8/23/24.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    
    @StateObject var camera = CameraModel()
    
    
    
    var body: some View {
        ZStack{
            Color(red: 0/255, green: 145/255, blue: 242/255)
                .ignoresSafeArea()
            VStack{
                Button(
                    action:{},
                    label:{
                        CameraRetakeButton()
                    }
                )
                Spacer()
                
                HStack{
                    //Toggles the Take Photo button
                    if camera.isTaken {
                        VStack{
                            Button(
                                action: {},
                                label: {
                                        CameraUnsaveButton()
                                }).padding(.leading)
                            Button(
                                action: {},
                                label: {
                                        CameraSaveButton()
                                }).padding(.leading)
                        }
                        
                        Spacer()
                    } else{
                        Button(action: {camera.isTaken.toggle()},label:{
                            ZStack{
                                CameraCaptureButton()
                            }
                        })
                        
                    }
                }
            }
        }
    }
}

#Preview {
    CameraView()
}

// Only classes can be observable objects
class CameraModel: ObservableObject{
    @Published  var isTaken = false
    @Published var session = AVCaptureSession()
    
    
    func setUp(){
        //Checking for camera permissions
        switch  AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
        
        default:
            return
        }
    }
}
