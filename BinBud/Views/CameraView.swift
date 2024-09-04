import SwiftUI
import AVFoundation

struct CameraView: View {
    
    // For Ternary Animations
    
    @State private var showHelpMenu = false
    @State private var hideCameraUI = false
    @State private var showSettings = false
    @State private var showOutput = false
    
    //For Camera API
    
    @State var camera = CameraModel()
    
    // For Model Output
    @State var outputData: [String: Any] = [:]
    @State var image: UIImage? = nil
    
    // For Double Taps
    @State private var doubleTapCount = 0
    @State private var tapCount = 0
    @State private var tapTimer: Timer?

    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea()
                .onReceive(NotificationCenter.default.publisher(for: .AVCaptureSessionRuntimeError), perform: { notification in
                    print("🤙 error!! \(notification.object)")
                })
                .onTapGesture(count: 2) {
                    print("double")
                    withAnimation{
                        camera.switchCamera()
                    }
                    
                }
            
            if !showHelpMenu && !showSettings {
                VStack {
                    ZStack {
                        HStack {
                            CameraSettingsButton()
                                .padding(.leading, 30)
                                .onTapGesture {
                                    withAnimation {
                                        self.showSettings.toggle()
                                        self.hideCameraUI = false
                                        
                                    }
                                }
                            Spacer()
                        }
                        CameraFlipButton().onTapGesture {
                            withAnimation {
                                camera.switchCamera()
                            }
                        }
                        HStack {
                            Spacer()
                            CameraHelpButton()
                                .padding(.trailing, 30)
                                .onTapGesture {
                                    withAnimation{
                                        self.showHelpMenu.toggle()
                                        self.hideCameraUI = false
                                    }
                                }
                        }
                    }
                    //Entrance or Default
                    .allowsHitTesting(!hideCameraUI || !showHelpMenu || !showSettings)
                    .offset(y: hideCameraUI || showHelpMenu || showSettings ? -UIScreen.main.bounds.height / 2 : 0)
                    .opacity(hideCameraUI || showHelpMenu || showSettings ? 0 : 1) // True -> visiable
                    
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
                                            self.hideCameraUI = false
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
                                                    self.hideCameraUI = true
                                                }
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
                                            self.hideCameraUI.toggle()
                                            
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Adjust the delay duration as needed
                                            camera.takePic()
                                        }
                                    }
                            }
                            .allowsHitTesting(!hideCameraUI || !showSettings || !showHelpMenu) // Disables interaction when top bar is hidden
                            .opacity(hideCameraUI || showHelpMenu || showSettings ? 0 : 1) // Adjust opacity based on hideCameraUI state
                            .offset(y: hideCameraUI || showHelpMenu || showSettings ? UIScreen.main.bounds.height / 1.4 : 0) // Move off-screen when fading out
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
                                                
                    } else {
                        CameraModelOutputView(modelOutput: "Unknown", modelInstructions: "Sorry! The servers are down!", modelConfidence: 0.0)
                    }
                }
                .padding(.bottom, 120)
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
    
//    func handleTap() {
//        tapCount += 1
//        
//        // Cancel any existing timer
//        tapTimer?.invalidate()
//
//        if tapCount == 2 {
//            print("double tap active")
//            doubleTapCount += 1
//            tapCount = 0 // Reset tap count after detecting double tap
//            withAnimation {
//                camera.switchCamera() // Switch the camera on double tap
//            }
//        } else {
//            // Start a timer to reset tapCount after a short interval
//            tapTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
//                tapCount = 0
//            }
//        }
//    }
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

