import SwiftUI
import AVFoundation

@Observable
class ViewModel {
    var showHelpMenu: Bool = false
    
    func showMenu() {
        showHelpMenu = true
    }
}

struct CameraView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @State private var viewModel = ViewModel()
    
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
    @State private var isCroppingView: Bool = false
    @State private var cropImageAction: Bool = false

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

        ZStack {
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
                                    // Call savePic and handle the returned dictionary
                                    
                                    //Old model call 1.01
//                                    self.outputData = camera.savePic()
                                    withAnimation {
//
                                        self.showOutput = false
                                        self.hideCameraUI = true
                                    }
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.9)) {
                                        print("Image has been captured")
                                        self.capturedImage = camera.showImage()
                                        self.isCroppingView = true
                                    }
                                }
                            }
                        CameraRetakeButton()
                            .padding(.leading, -150)
                            .onTapGesture {
                                withAnimation {
                                    self.finalCroppedImage = nil
                                    self.showOutput = false
                                    self.hideCameraUI = false
                                    camera.retakePic()
                                }
                            }
                    }
                }
                .opacity(camera.isTaken ? 1.0 : 0)
                .offset(y: camera.isTaken ? 0 : 600)
                .transition(.move(edge: .bottom))
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

            // Toggle cropping view based on the boolean `isCroppingView`
            if self.isCroppingView {
                HStack {
                    ZStack {
                        HStack {
                            Spacer()
                            SkipCroppingButton()
                                .frame(width: 180, height: 120)
                                .onTapGesture {
                                    
                                    // For restarting
                                    withAnimation {
                                        // preprocess Image
                                        camera.imageToUse = capturedImage!
                                        self.camera.retakePic()
                                        self.hideCameraUI = false
                                        self.outputData = camera.processImage()
                                        self.showOutput = true
                                        self.isCroppingView = false
                                        
                                        self.finalCroppedImage = nil
                                        
                                        

                                        
                                        }
                                }
                            Spacer(minLength: 20)
                            CropButton()
                                .frame(width: 180, height: 120)
                                .onTapGesture {
                                    self.cropImageAction = true
                                }
                            Spacer()
                        }
                    }
                }
                .opacity(isCroppingView ? 1.0 : 0)
                .offset(y: isCroppingView ? 0 : 600)
                .transition(.move(edge: .bottom))
                .zIndex(4)
                .padding(.top, 600)
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
                    Text("back button")
                        .padding()
                        .background(Color.black.gradient)
                        .foregroundColor(Color.white)
                        .padding(.top, 400)
                        .onTapGesture {
                            //Go back to the main view
                            self.finalCroppedImage = nil
                            self.showOutput = false
                            self.hideCameraUI = false
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
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            
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

        // Cropping View based on boolean
        if isCroppingView, let capturedImage = capturedImage {
            ZStack {
                GeometryReader { geometry in
                    Image(uiImage: capturedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(x: -geometry.size.width * 0.01)
                        .ignoresSafeArea()
                        .zIndex(3)
                        .transition(.move(edge: .top))
                        .background(Color.black.opacity(0.3))
                        .overlay {
                            // Only show BoundsView and handle cropping logic without displaying the image
                            BoundsView(finalCroppedImage: $finalCroppedImage, showCroppedImage: $showCroppedImage, isCropping: self.$cropImageAction)
                                .ignoresSafeArea()
                        }
                        .onChange(of: finalCroppedImage) { newValue in
                            if let croppedImage = newValue {
                                // process Image through model
                                camera.imageToUse = croppedImage
                                self.camera.retakePic()
                                self.hideCameraUI = false
                                self.outputData = camera.processImage()
                                self.showOutput = true
                                self.isCroppingView = false
                                
                                
//                              // GO back to main view
                                
                                self.finalCroppedImage = nil
                                
                                
                                
                                
                                
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
