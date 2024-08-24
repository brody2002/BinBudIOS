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
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea()

            VStack {
                Button(action: {}, label: {
                    CameraRetakeButton()
                })
                Spacer()

                HStack {
                    if camera.isTaken {
                        VStack {
                            Button(action: camera.retakePic, label: {
                                CameraUnsaveButton()
                            }).padding(.leading)

                            Button(action: {}, label: {
                                CameraSaveButton()
                            }).padding(.leading)
                        }

                        Spacer()
                    } else {
                        Button(action: camera.takePic, label: {
                            ZStack {
                                CameraCaptureButton()
                            }
                        })
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)  
        
        
        
        // This hides the back button in the navigation bar
        
        // Note: When this is here it causes massive delays for some reason
        // .onAppear(perform: {
        //     print("checking for permissions")
        //     camera.check()
        // })
    }
}

#Preview {
    CameraView()
}


struct CameraPreview : UIViewRepresentable {
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> UIView{
        let view = UIView(frame: UIScreen.main.bounds)
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        // You own properties
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        //starting the camera session()
        
        // Start the camera session on a background thread
        
        DispatchQueue.global(qos: .userInitiated).async {
            camera.session.startRunning()
        }
        
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context){
        // Updating the ui
        // I presume graphics
    }
}
