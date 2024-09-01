
import SwiftUI
import AVFoundation

struct CameraView: View {
    @State private var showHelpMenu = false
    @State private var showTopBar = false
    @State private var showSettings = false
    @State private var showOutput = false
    @State var camera = CameraModel()
    @State var outputData: [String: Any] = [:]
    @State var image: UIImage? = nil

    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea()
                .onReceive(NotificationCenter.default.publisher(for: .AVCaptureSessionRuntimeError), perform: { notification in
                    print("🤙 error!! \(notification.object)")
                })
            
            if !showHelpMenu && !showSettings {
                VStack {
                    ZStack {
                        HStack {
                            CameraSettingsButton()
                                .padding(.leading, 30)
                                .onTapGesture {
                                    withAnimation {
                                        self.showSettings.toggle()
                                        self.showTopBar = false
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
                                        self.showHelpMenu.toggle()
                                        self.showTopBar = false
                                        print("toggle button")
                                    }
                                }
                        }
                    }
                    //Entrance or Default
                    .allowsHitTesting(!showTopBar || !showHelpMenu || !showSettings)
                    
                    .opacity(showTopBar || showHelpMenu || showSettings ? 0 : 1) // True -> visiable
                    .offset(y: showTopBar || showHelpMenu || showSettings ? -UIScreen.main.bounds.height / 2 : 0)
                    .transition(.move(edge: .top).combined(with: .opacity)) // Move and fade out together

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
                                            
                                            // Call savePic and handle the returned dictionary
                                            camera.savePic { returnedData in
                                                self.outputData = returnedData
                                                
                                                withAnimation {
                                                    print("Cameraview dict: \(self.outputData)")
                                                    self.showOutput = true
                                                    self.showTopBar = true
                                                }
                                                print("Saved image")
                                                print("Showing output")
                                                print("Output data: \(self.outputData)")
                                            }
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
                            .allowsHitTesting(!showTopBar || !showSettings || !showHelpMenu) // Disables interaction when top bar is hidden
                            .opacity(showTopBar || showHelpMenu || showSettings ? 0 : 1) // Adjust opacity based on showTopBar state
                            .offset(y: showTopBar || showHelpMenu || showSettings ? UIScreen.main.bounds.height / 1.4 : 0) // Move off-screen when fading out
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                }
            }
            
            if showHelpMenu {
                CameraHelpToolbar(showHelpMenu: $showHelpMenu)
                    .cornerRadius(40)
                    .transition(.move(edge: .bottom))
                    .offset(y: showHelpMenu ? 20 : UIScreen.main.bounds.height)
            }
            
            if showOutput {
                ZStack {
                    if let label1 = self.outputData["label_1"] as? String {
                        CameraModelOutputView(modelOutput: label1, modelInstructions: self.outputData["label_2"] as! String, modelConfidence: self.outputData["confidence"] as! Double)
                                                .padding(.bottom, 120)
                    } else {
                        Text("No output available").padding(.bottom, 120)
                    }
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
