import SwiftUI
import AVFoundation


struct CameraView: View {
    @Environment(\.scenePhase) var scenePhase
    @State private var showHelpMenu = false
    @State var hideCameraUI: Bool
    @State private var showSettings = false
    @State private var showOutput = false
    
    // For Camera API
    @State var camera = CameraModel()
    
    // For Model
    
    @State var outputData: [String: Any] = [:]
    @State var image: UIImage? = nil
    
    // For Cropping
    @State private var showCroppedImage: Bool = false
    @State private var finalCroppedImage: UIImage? = nil
    
    // To display the captured image
    @State private var capturedImage: UIImage? = nil

    @Binding var checkPermissions: Bool
    
    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea()
                .onReceive(NotificationCenter.default.publisher(for: .AVCaptureSessionRuntimeError), perform: { notification in
                    print("🤙 error!! \(String(describing: notification.object))")
                })
                .onTapGesture(count: 2) {
                    print("double")
                    withAnimation {
                        camera.switchCamera()
                    }
                }
        }.zIndex(0.0)
        ZStack{
            
        
            
            if !showHelpMenu && !showSettings {
                VStack {
                    ZStack {
                        HStack {
                            CameraSettingsButton()
                                .padding(.leading, 30)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
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
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                                        self.showHelpMenu.toggle()
                                        self.hideCameraUI = false
                                    }
                                }
                        }
                    }
                    .allowsHitTesting(!hideCameraUI || !showHelpMenu || !showSettings)
                    .offset(y: hideCameraUI || showHelpMenu || showSettings ? -UIScreen.main.bounds.height / 2 : 0)
                    .opacity(hideCameraUI || showHelpMenu || showSettings ? 0 : 1)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.bottom, 720)
                }
            }
            
            if camera.isTaken {
                HStack {
                    ZStack {
                        CameraSaveButton()
                            .padding(.leading, 195)
                            .onTapGesture {
                                if !camera.isSaved {
                                    self.outputData = camera.savePic()
                                    
                                    withAnimation {
                                        print("Cameraview dict: \(self.outputData)")
                                        self.showOutput = false /*true*/
                                        self.hideCameraUI = true
                                    }
                                    // Capture the image and show it
                                    var curImage = camera.showImage()
                                    self.capturedImage = curImage
                                }
                            }
                        CameraRetakeButton()
                            .padding(.leading, -150)
                            .onTapGesture {
                                withAnimation {
                                    self.showOutput = false
                                    self.hideCameraUI = false
                                    camera.retakePic()
                                    self.showCroppedImage = false
                                    self.capturedImage = nil
                                }
                            }
                    }
                }
                .opacity(camera.isTaken ? 1.0 : 0)
                .offset(y: camera.isTaken ? 0 : 600)
                .transition(.move(edge: .bottom))
                .zIndex(4)
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
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                camera.takePic()
                            }
                        }
                }
                .padding(.top, 600)
                .allowsHitTesting(!hideCameraUI || !showSettings || !showHelpMenu)
                .opacity(hideCameraUI || showHelpMenu || showSettings ? 0 : 1)
                .offset(y: hideCameraUI || showHelpMenu || showSettings ? UIScreen.main.bounds.height / 1.4 : 0)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            if showHelpMenu {
                CameraHelpToolbar(showHelpMenu: $showHelpMenu)
                    .cornerRadius(40)
                    .transition(.move(edge: .bottom))
                    .offset(y: showHelpMenu ? 80 : UIScreen.main.bounds.height)
                    .zIndex(2) // Ensure it's on top
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
                SettingsView(showSettings: $showSettings, hideCameraUI: $hideCameraUI)
                    .offset(x: showSettings ? 0 : -UIScreen.main.bounds.width)
                    .transition(.move(edge: .leading))
            }
            
            // Display the captured image when available
            
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            print("Opening CameraView! Permission: \(checkPermissions)")
            if self.checkPermissions {
                camera.check()
            }
            checkPermissions = true
        }
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .active:
                print("App is active")
                if self.checkPermissions {
                    camera.check()
                }
            case .inactive:
                print("App is inactive")
            case .background:
                print("App is in the background")
            @unknown default:
                print("Unexpected new scene phase: \(newPhase)")
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            print("App is returning to the foreground.")
            if self.checkPermissions {
                camera.check()
            }
        }
        .zIndex(2.0)
        
        
        
        if let capturedImage = capturedImage {
            ZStack {
                    GeometryReader { geometry in
                        Image(uiImage: capturedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height) // Match the image to the screen size
                            .offset(x: -geometry.size.width * 0.01) // Adjust this to shift the image to the left (e.g., 10% of the screen width)
                            .ignoresSafeArea()
                            .zIndex(3) // Bring the captured image to the front
                            .transition(.move(edge: .top))
                            .background(Color.black.opacity(0.5)) // Optional background for visibility
                        
                        .overlay {
                            // Display BoundsView only when the camera has taken a picture (i.e., camera.isTaken is true)
                            if camera.isTaken {
                                BoundsView(finalCroppedImage: $finalCroppedImage, showCroppedImage: $showCroppedImage)
                                    .ignoresSafeArea()
                            }
                            
                            if showCroppedImage, let finalCroppedImage = finalCroppedImage {
                                // Show cropped image
                                Image(uiImage: finalCroppedImage)
                                    .resizable()
                                    .scaledToFit()
                                    .ignoresSafeArea()
                            }
                        }
                    }
                }
                .ignoresSafeArea(edges: .all)
                .zIndex(1.0)
                
            
        }
    }
}

#Preview {
    CameraView(hideCameraUI: false, checkPermissions: .constant(false))
}



struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .black
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        camera.preview.videoGravity = .resizeAspectFill
//        camera.preview.videoGravity = .resizeAspect

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
