//
//  CameraModel.swift
//  BinBud
//
//  Created by Brody on 8/23/24.
//

import Foundation
import SwiftUI
import AVFoundation


// Only classes can be observable objects
class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate{
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var preview : AVCaptureVideoPreviewLayer!
    @Published var isSaved = false
    
    
    func check(){
        
        //Checking for camera permissions
        switch  AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            print("authorized")
            setUp()
            return
            //Setting up the session
        case .notDetermined :
            print("notDetermined")
            //Retrusting Permissions
            AVCaptureDevice.requestAccess(for: .video) { status in
                if status {
                    print("status true")
                    self.setUp() // Call your setup method if access is granted
                    
                } else {
                    // Handle the case where access is denied
                    print("else")
                    
                    
                }
            }
        case .denied :
            self.alert.toggle()
            print("denied")
            DispatchQueue.main.async {
                self.showSettingsAlert()
            }
            return
        
        default:
            print("default")
            return
        }
    }
    
    func setUp() {
        //Setting up the Camera
        do{
            //settings config:
            self.session.beginConfiguration()
            
            //change for your own...
            let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
            //Editied
            let input = try AVCaptureDeviceInput(device: device!)
            
            //Checking and adding to session
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            
            //Same for input
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
            
        }
        catch{print(error.localizedDescription)}
    }
    
    func takePic() {
        DispatchQueue.global(qos: .background).async {
            print("takePic() called ")
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            self.session.stopRunning()
            
            // Ensure that the state change happens on the main thread but outside of view updates
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                withAnimation { self.isTaken.toggle() }
            }
        }
    }

    func retakePic() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            
            // Ensure that the state change happens on the main thread but outside of view updates
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                withAnimation { self.isTaken.toggle() }
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error :Error?) {
        print("test the photoOutputfunction")
        if error != nil{
            return
        }
        print("pic taken!")
    }
    func showSettingsAlert() {
            let alert = UIAlertController(
                title: "Camera Access Needed",
                message: "Please enable camera access in your settings to use the camera features.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }))
            
            // Get the topmost view controller to present the alert
            if let topController = UIApplication.shared.windows.first?.rootViewController {
                topController.present(alert, animated: true, completion: nil)
            }
        }
    
}

