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
class CameraModel: ObservableObject{
    @Published  var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    
    func check(){
        //Checking for camera permissions
        switch  AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
            //Setting up the session
        case .notDetermined :
            //Retrusting Permissions
            AVCaptureDevice.requestAccess(for: .video) { status in
                if status {
                    self.setUp() // Call your setup method if access is granted
                } else {
                    // Handle the case where access is denied
                }
            }
        case .denied :
            self.alert.toggle()
            return
        
        default:
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
    
    
}
