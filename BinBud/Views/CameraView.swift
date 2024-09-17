import SwiftUI
import AVFoundation

struct CameraView: View {
    
    // For Ternary Animations
    @State private var showHelpMenu = false
    @State var hideCameraUI : Bool
    @State private var showSettings = false
    @State private var showOutput = false
    
    //For Camera API
    @State var camera = CameraModel()
    
    // For Model Output
    @State var outputData: [String: Any] = [:]
    @State var image: UIImage? = nil

    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea()
                .onReceive(NotificationCenter.default.publisher(for: .AVCaptureSessionRuntimeError), perform: { notification in
                    print("🤙 error!! \(String(describing: notification.object))")
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
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.9)){
                                        self.showSettings = true
                                        self.hideCameraUI = true
                                        
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
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.9)){
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
                    
                    .padding(.bottom, 720)
                    
                    
                        
                    
                }
            }
            
            if camera.isTaken {
                HStack{
                    ZStack {
                        
                        CameraSaveButton()
                            .padding(.leading,195)
                        
                            .onTapGesture {
                                if !camera.isSaved {
                                    
                                    // Call savePic and handle the returned dictionary
                                    self.outputData = camera.savePic()
                                    
                                        
                                        withAnimation {
                                            print("Cameraview dict: \(self.outputData)")
                                            self.showOutput = true
                                            self.hideCameraUI = true
                                        }
                                    
                                }
                            }
                        CameraRetakeButton()
                        
                            .padding(.leading,-145)
                        
                            .onTapGesture {
                                withAnimation {
                                    self.showOutput = false
                                    self.hideCameraUI = false
                                    camera.retakePic()
                                }
                            }
                    }
                }
                .opacity(camera.isTaken ? 1.0 : 0)
                .offset(y: camera.isTaken ? 0 : 600)
                .transition(.move(edge:.bottom))
                .zIndex(1)
                
                .padding(.top, 600)
                
               
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
                .padding(.top, 600)
                .allowsHitTesting(!hideCameraUI || !showSettings || !showHelpMenu) // Disables interaction when top bar is hidden
                .opacity(hideCameraUI || showHelpMenu || showSettings ? 0 : 1) // Adjust opacity based on hideCameraUI state
                .offset(y: hideCameraUI || showHelpMenu || showSettings ? UIScreen.main.bounds.height / 1.4 : 0) // Move off-screen when fading out
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            
            if showHelpMenu {
                CameraHelpToolbar(showHelpMenu: $showHelpMenu)
                    .cornerRadius(40)
                    .transition(.move(edge: .bottom))
                    .offset(y: showHelpMenu ? 80 : UIScreen.main.bounds.height)
                    .transition(.move(edge: .bottom)) // Apply transition animation
                                        .zIndex(1) // Ensure it's on top
            }
            
            if showOutput {
                ZStack {
                    if let label1 = self.outputData["label_1"] as? String {
                        CameraModelOutputView(modelOutput: label1 , modelInstructions: self.outputData["label_2"] as! String, modelConfidence: self.outputData["confidence"] as! Double)
                                                
                    } else {
                        CameraModelOutputView(modelOutput: "Unknown", modelInstructions: "Sorry! The servers are down!", modelConfidence: 0.0)
                    }
                }
                .padding(.bottom, 120)
                .transition(.scale)
            }
                
            if showSettings {
                SettingsView(showSettings: $showSettings, hideCameraUI: $hideCameraUI)
                     // Transition from the left
                    .offset(x: showSettings ? 0 : -UIScreen.main.bounds.width)
                    .transition(.move(edge: .leading))
            }
        }
        .navigationBarBackButtonHidden(true)
    }

}

#Preview {
    CameraView(hideCameraUI: false)
}



struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .black
        
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

