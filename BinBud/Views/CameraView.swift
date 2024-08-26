import SwiftUI
import AVFoundation

struct CameraView: View {
    @State private var showMenu = false
    @State private var showTopBar = false
    @StateObject var camera = CameraModel()
    
    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea()
                .onReceive(NotificationCenter.default.publisher(for: .AVCaptureSessionRuntimeError), perform: { notification in
                    print("🤙 error!! \(notification.object)")
                })
            
           
            
            if !showMenu{
                VStack {
                    if showTopBar {}
                    ZStack {
                        CameraFlipButton()
                        HStack {
                            Spacer()
                            
                            CameraHelpButton()
                                .padding(.trailing, 30)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.3)){
                                        camera.tempStop()
                                        self.showMenu.toggle()
                                        print("toggle button")
                                    }
                                }
                            
                        }
                    }.allowsHitTesting(showTopBar ? false : true)
                        .opacity(showTopBar ? 0.0 : 1.0)

                    
                    Spacer()
                    
                    HStack {
                        if camera.isTaken {
                            
                            VStack {
                                CameraRetakeButton()
                                    .padding(.leading)
                                    .onTapGesture {
                                        self.showTopBar.toggle()
                                        camera.retakePic()
                                    }
                                CameraSaveButton()
                                    .padding(.leading)
                                    .onTapGesture {
                                        if !camera.isSaved {
                                            camera.savePic()
                                            print("saved image")
                                            // IMPORTANT: After picture is saved here, do something with your model here as well.
                                        }
                                    }
                            }
                            
                            Spacer()
                        } else {
                            
                            CameraCaptureButton()
                                .onTapGesture {
                                    self.showTopBar.toggle()
                                    camera.takePic()
                                }
                        }
                    }
                }
            
        }
            
            
            if showMenu {
                CameraHelpToolbar(showMenu: $showMenu)
                    .cornerRadius(40)
                    .transition(.move(edge: .bottom))
                    .offset(y: showMenu ? 40 : UIScreen.main.bounds.height)
                    
                    

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

