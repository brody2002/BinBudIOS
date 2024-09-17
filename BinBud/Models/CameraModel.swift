//
//  CameraModel.swift
//  BinBud
//
//  Created by Brody on 8/23/24.
//

import Foundation
import SwiftUI
import AVFoundation
import UIKit
import CoreML




@Observable class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate{
    var isTaken = false
    var session = AVCaptureSession()
    var alert = false
    var output = AVCapturePhotoOutput()
    var preview : AVCaptureVideoPreviewLayer!
    var isSaved = false
    var picData = Data(count: 0)
    var BinBudOutput = BinBudModel()
    
    
    
    

    func switchCamera() {
        print("entered switchCamera()")
        guard let currentInput = session.inputs.first as? AVCaptureDeviceInput else {
            return
        }
        do {
            self.session.beginConfiguration()
            
            
            self.session.removeInput(currentInput)
            
            // Determine the new camera position being front or back
            let newCameraPosition: AVCaptureDevice.Position = currentInput.device.position == .back ? .front : .back
            
            print("Camera pos: \(newCameraPosition)")
            
            
            let newDevice: AVCaptureDevice?
            if newCameraPosition == .back {
                
                newDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
            } else {
                newDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            }
            
            // Create input from the new device
            let input = try AVCaptureDeviceInput(device: newDevice!)
            
            // If for some reason there is no session...
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            
            // Ensure the output is still there
            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
            
        } catch {
            print(error.localizedDescription)
        }
    }


    
    func check(){
            
            //Checking for camera permissions
            switch  AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                print("camera settings authorized")
                setUp()
                return
                //Setting up the session
            case .notDetermined :
                print("camera settings notDetermined")
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
                print("adding session")
                self.session.addInput(input)
            }
            
            //Same for input
            if self.session.canAddOutput(self.output){
                print("same session being used")
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
            
        }
        catch{print(error.localizedDescription)}
    }
    
    func takePic() {
        DispatchQueue.global(qos: .background).async {
            print("takePic() called ")
            print("Delegate is set to: \(self)")
            if self.session.isRunning {
                print("Session is running")
            } else {
                print("Session is not running")
                self.session.startRunning() // Start it if needed
                
                if self.session.isRunning{
                    print("now is running")
                }
            }
            
            
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                        self.session.stopRunning()
                        print("Session stopped after delay")
                    }
            // Ensure that the state change happens on the main thread but outside of view updates
            DispatchQueue.main.async{
                withAnimation(.spring(response:0.6, dampingFraction: 1.4)) { self.isTaken.toggle() }
            }

        }
    }

    func retakePic() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            
            // Ensure that the state change happens on the main thread but outside of view updates
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.04) {
                withAnimation (.spring(response:0.6, dampingFraction: 1.4)) { self.isTaken.toggle() }
                self.isSaved = false
            }
        }
    }
    
    //Function is called from the capturePhoto() function!
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error :Error?) {
        print("test the photoOutputfunction")
        if error != nil{
            return
        }
        print("pic taken!")
        
        guard let imageData = photo.fileDataRepresentation() else{return}
        
        self.picData = imageData
        
        
    }
    
    
    func savePic() -> [String: Any] {
        let curImage = UIImage(data: self.picData)!
        
        // Resizing Image for input of BinBud Model
        let targetSize = CGSize(width: 224, height: 224)
        let resizedImage = self.resizeImage(image: curImage, targetSize: targetSize)
        
        print("savedImage Successfully. Going to model call() ")
        self.isSaved = true
        

        
//        // Call runModel and handle the completion
        let modelOutput = self.runModel(image : resizedImage)
        return modelOutput
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        // This will force the image to the target size without maintaining aspect ratio
        let rect = CGRect(origin: .zero, size: targetSize)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func runModel(image: UIImage) -> [String:  Any] {
        
        // CoreML Package Code:
        
        
        do {
            let model = try BinBudFinalModel2(configuration: MLModelConfiguration())
            
            // Convert UIImage to CVPixelBuffer (CoreML requires input as CVPixelBuffer)
            guard let pixelBuffer = image.toCVPixelBuffer() else {
                print("Failed to convert UIImage to CVPixelBuffer")
                return [:]
            }
            
            // Perform prediction
            let prediction = try model.prediction(input_3: pixelBuffer)
            print("Prediction: \(prediction.classLabel) ANSWER")
            print("label prediction numbers: \(prediction.classLabel_probs)")
            // Find max val in dict
            if let maxValue = prediction.classLabel_probs.values.max() {
                print("The largest value is \(maxValue)")
                
                let d : [String : Any] = [
                    "label_1": prediction.classLabel,
                    "label_2" : BinBudOutput.outputMessage(input: prediction.classLabel, value: Float(maxValue)),
                    "confidence" : Double(maxValue)
                ]
                
                return d
            }
            else{
                return [:]
            }
            
                    
                        
            } catch {
                print("Error initializing model or making prediction: \(error)")
            }
        return [:]
        
        
        
        
        // Default HTTP POST Request:
//        
//        
//        let serverURL = URL(string: "https://brody711.pythonanywhere.com/upload")!
//        print("sending to server")
//        self.sendImageToServer(image: image, url: serverURL){ outputDict in
//                                completion(outputDict) // Pass the result back via the completion handler
//                            }
        
        
//        //Code below is for local server!!!
//        
//        // Set up a URL request with a short timeout interval
//        var request = URLRequest(url: serverURL)
//        request.httpMethod = "POST" // Check if the server is available without sending data
//        request.timeoutInterval = 3 // Set a timeout interval of 5 seconds (or adjust as needed)
//        
//        URLSession.shared.dataTask(with: request) { _, response, error in
//            if let error = error {
//                // If the URL is not reachable or there is a network error, print error and return empty dict
//                print("Error: Could not reach server: \(error.localizedDescription)")
//                completion([:]) // Return empty dictionary in case of error
//                return
//            }
//            
//            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
//                // If the server responds with a valid status code, proceed with sending the image
//                self.sendImageToServer(image: image, url: serverURL) { outputDict in
//                    completion(outputDict) // Pass the result back via the completion handler
//                }
//            } else {
//                // If the server returns an invalid status code, handle it
//                print("Server responded with a status code: \(response.debugDescription)")
//                completion([:]) // Return empty dictionary if the status code is invalid
//            }
//        }.resume()
    }



    func sendImageToServer(image: UIImage, url: URL, completion: @escaping ([String: Any]) -> Void) {
        // Convert UIImage to JPEG data
        print("sending image to server call() ")
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            print("Failed to convert UIImage to data.")
            completion([:])
            return
        }

        // Generate boundary string using a unique per-app string
        let boundary = UUID().uuidString

        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        print("TEST 3")
        // Set Content-Type Header to multipart/form-data and the boundary
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // Create the form data with the boundary
        var data = Data()
        
        // Add the image data to the raw HTTP request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"BinBudImage.jpg\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append(imageData)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Send a POST request to the URL, with the data we created earlier
        URLSession.shared.uploadTask(with: urlRequest, from: data) { responseData, response, error in
            if let error = error {
                print("Error sending image: \(error.localizedDescription)")
                completion([:]) // Return an empty dictionary in case of error
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("HTTP Response: \(response.statusCode)")
            }
            
            guard let responseData = responseData else {
                print("No response data received.")
                completion([:]) // Return an empty dictionary if no data is received
                return
            }
            
            do {
                print("do")
                // **Parsing the JSON response**:
                if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                    print("Parsed JSON Response: \(json)")
                    
                    // **Extracting values from the parsed JSON response**:
                    if let label1 = json["label_1"] as? String,
                       let confidence = json["confidence"] as? Double,
                       let label2 = json["label_2"] as? String {
                        
                        print("parsing")
                        var result: [String: Any] = [:]
                        result["label_1"] = label1
                        result["confidence"] = confidence
                        result["label_2"] = label2
                        completion(result) // Return the result dictionary
                        return
                    } else {
                        print("Unexpected response format.")
                        completion([:])
                        return
                    }
                } else {
                    print("Failed to cast JSON response to dictionary.")
                    completion([:])
                }
            } catch {
                print("Failed to parse JSON response: \(error.localizedDescription)")
                completion([:])
            }
        }.resume()
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
                if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                   let keyWindow = windowScene.keyWindow,
                   let topController = keyWindow.rootViewController {

                    // Traverse to the top-most presented view controller
                    var currentController = topController
                    while let presentedViewController = currentController.presentedViewController {
                        currentController = presentedViewController
                    }

                    // Present the alert on the top-most view controller
                    currentController.present(alert, animated: true, completion: nil)
                }
        }

}


    

    

    
    


// Code found from https://www.createwithswift.com/uiimage-cvpixelbuffer-converting-an-uiimage-to-a-pixelbuffer/
extension UIImage {
        
    func toCVPixelBuffer() -> CVPixelBuffer? {
        
        let attributes = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
        ] as CFDictionary
        
        var pixelBuffer: CVPixelBuffer?
        
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault, Int(self.size.width),
            Int(self.size.height),
            kCVPixelFormatType_32ARGB,
            attributes,
            &pixelBuffer)
        
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        
        let context = CGContext(
            data: pixelData,
            width: Int(self.size.width),
            height: Int(self.size.height),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!),
            space: rgbColorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        UIGraphicsPopContext()
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}

