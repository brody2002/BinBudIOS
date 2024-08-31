
import SwiftUI
import AVFoundation

struct CameraView: View {
    @State private var showMenu = false
    @State private var showTopBar = false
    @State private var showSettings = false
    @State private var showOutput = false
    @State var camera = CameraModel()
    @State var modelOuput = ""
    
    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea()
                .onReceive(NotificationCenter.default.publisher(for: .AVCaptureSessionRuntimeError), perform: { notification in
                    print("🤙 error!! \(notification.object)")
                })
            
            if !showMenu && !showSettings {
                VStack {
                    ZStack {
                        HStack {
                            CameraSettingsButton()
                                .padding(.leading, 30)
                                .onTapGesture {
                                    withAnimation{
                                        self.showSettings.toggle()
                                        print("show settings true")
                                    }
                                }
                            Spacer()
                        }
                        CameraFlipButton().onTapGesture {
                            withAnimation {
                                print("CameraFlipButton tapped")
                                camera.switchCamera()
                            }
                        }
                        HStack {
                            Spacer()
                            CameraHelpButton()
                                .padding(.trailing, 30)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        

                                        self.showMenu.toggle()
                                        print("toggle button")
                                    }
                                }
                        }
                    }
                    // NOT WORKING :(
                    .allowsHitTesting(!showTopBar || !showMenu || !showSettings) // Disable interaction when top bar, menu, or settings is hidden
                    .opacity(showTopBar || showMenu || showSettings ? 0 : 1) // Adjust opacity based on state
                    .offset(y: showTopBar || showMenu || showSettings ? -UIScreen.main.bounds.height / 2 : 0) // Move off-screen when fading out
                    .transition(.move(edge: .top).combined(with: .opacity)) // Apply transition
                    .animation(.easeInOut(duration: 0.5), value: showTopBar || showMenu || showSettings) // Animate based on states


                    Spacer()
                    
                    HStack {
                        if camera.isTaken {
                            VStack {
                                CameraRetakeButton()
                                    .padding(.leading)
                                    .onTapGesture {
                                        withAnimation {
                                            self.showOutput = false
                                            self.showTopBar = false
                                            camera.retakePic()
                                        }
                                    }
                                CameraSaveButton()
                                    .padding(.leading)
                                    .onTapGesture {
                                        if !camera.isSaved {
                                            self.modelOuput = camera.savePic()
                                            withAnimation {
                                                self.showOutput = true
                                                self.showTopBar = true
                                            }
                                            print("saved image")
                                            print("showing output")
                                        }
                                    }
                            }
                            
            
            
                            
                            
                            
                            
                            Spacer()
                        } else {
                            VStack {
                                CameraInstructionView()
                                    .padding(.bottom, 30)
                                CameraCaptureButton()
                                    .padding(.bottom, 60)
                                    .onTapGesture {
                                        withAnimation {
                                            self.showTopBar.toggle()
                                            
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Adjust the delay duration as needed
                                            camera.takePic()
                                                    }
                                    }
                            }
                            .allowsHitTesting(!showTopBar) // Disables interaction when top bar is hidden
                            .opacity(showTopBar ? 0 : 1) // Adjust opacity based on showTopBar state
                            .offset(y: showTopBar ? UIScreen.main.bounds.height / 1.4 : 0) // Move off-screen when fading out
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                }
            }
            
            if showMenu {
                
                CameraHelpToolbar(showMenu: $showMenu)
                    .cornerRadius(40)
                    .transition(.move(edge: .bottom))
                    .offset(y: showMenu ? 20 : UIScreen.main.bounds.height)
                    
            }
            
            if showOutput {
                ZStack {
                    CameraModelOutputView(modelOutput: self.modelOuput)
                        .padding(.bottom, 120)
                }
                .transition(.scale)
            }
            
            if showSettings {
                SettingsView(showSettings: $showSettings)
                    .transition(.move(edge: .leading)) // Transition from the left
                    .offset(x: showSettings ? 0 : -UIScreen.main.bounds.width)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CameraView()
}

struct CameraPreview: UIViewRepresentable {
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
