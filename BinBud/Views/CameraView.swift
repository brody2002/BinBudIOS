import SwiftUI
import AVFoundation

struct CameraView: View {
    @State private var showMenu = false
    @StateObject var camera = CameraModel()
    
    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea()
            
            if !showMenu {
                VStack {
                    ZStack {
                        Button(action: {}, label: {
                            CameraFlipButton()
                        })
                        HStack {
                            Spacer()
                            Button(action: {
                                withAnimation{
                                    self.showMenu = true
                                    print("menu will be shown")
                                }
                            
                            }, label: {
                                CameraHelpButton()
                            }).padding(.trailing, 30)
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        if camera.isTaken {
                            VStack {
                                Button(action: camera.retakePic, label: {
                                    CameraUnsaveButton()
                                }).padding(.leading)
                                
                                Button(action: { if !camera.isSaved {
                                    camera.savePic()
                                    // IMPORTANT: After picture is saved here, do something with your model here as well.
                                }}, label: {
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
            
            if showMenu {
                GeometryReader { geometry in
                    CameraHelpToolbar(showMenu: $showMenu)
                        .offset(y: geometry.size.height) // Start from the bottom
                                               .transition(.move(edge: .bottom)) // Transition from the bottom edge
                                               .animation(.easeInOut(duration: 0.5), value: showMenu) // Animate the transition
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CameraView()
}

struct CameraPreview : UIViewRepresentable {
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        DispatchQueue.global(qos: .userInitiated).async {
            camera.session.startRunning()
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Updating the UI
    }
}

