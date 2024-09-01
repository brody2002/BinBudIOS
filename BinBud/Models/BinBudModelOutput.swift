import Foundation
import CoreML
import SwiftUI

class BinBudModel: ObservableObject {
    @Published var outputItem = ""
    @Published var message = ""
    
    let outputs: [String] = ["battery", "biological", "cardboard", "cement", "clothes", "electronics", "glass", "leather", "metal", "paper", "plastic", "rubber", "trash", "wood"]

    func findMaxValueInMultiArray(outputArray: MLMultiArray) -> String {
        guard outputArray.shape.count == 2, outputArray.shape[0].intValue == 1, outputArray.shape[1].intValue == 14 else {
            print("Unexpected MultiArray shape.")
            return ""
        }
        
        let arrayPointer = outputArray.dataPointer.bindMemory(to: Float32.self, capacity: outputArray.count)
        let array = Array(UnsafeBufferPointer(start: arrayPointer, count: outputArray.count))
        
        if let maxValue = array.max(), let maxIndex = array.firstIndex(of: maxValue) {
            DispatchQueue.main.async { [weak self] in
                self?.outputItem = self?.outputs[maxIndex] ?? ""
                
            }
            print(maxValue, maxIndex, outputs[maxIndex])
            
            return outputs[maxIndex]
        }
        
        return ""
    }
    
    func normalizeImageColors(image: UIImage, bias: [CGFloat]) -> UIImage? {
        guard bias.count == 3 else {
            print("Bias array must have exactly 3 elements for RGB.")
            return nil
        }

        guard let cgImage = image.cgImage else {
            print("Failed to get CGImage from UIImage.")
            return nil
        }

        let width = cgImage.width
        let height = cgImage.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue

        guard let context = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo) else {
            print("Failed to create CGContext.")
            return nil
        }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        guard let pixelBuffer = context.data else {
            print("Failed to get pixel data from context.")
            return nil
        }

        let pixels = pixelBuffer.bindMemory(to: UInt8.self, capacity: width * height * bytesPerPixel)

        for y in 0..<height {
            for x in 0..<width {
                let pixelIndex = (y * width + x) * bytesPerPixel
                
                let rIndex = pixelIndex
                let gIndex = pixelIndex + 1
                let bIndex = pixelIndex + 2

                pixels[rIndex] = clampValue(value: CGFloat(pixels[rIndex]) + bias[0])
                pixels[gIndex] = clampValue(value: CGFloat(pixels[gIndex]) + bias[1])
                pixels[bIndex] = clampValue(value: CGFloat(pixels[bIndex]) + bias[2])
            }
        }

        guard let newCgImage = context.makeImage() else {
            print("Failed to create CGImage from context.")
            return nil
        }

        return UIImage(cgImage: newCgImage)
    }

    private func clampValue(value: CGFloat) -> UInt8 {
        return UInt8(min(max(value, 0), 255))
    }
    
    
}

