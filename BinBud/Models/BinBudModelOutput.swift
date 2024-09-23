import Foundation
import CoreML
import SwiftUI

class BinBudModel: ObservableObject {
    @Published var outputItem = ""
    @Published var message = ""
    
    func outputMessage(input: String, value: Float) -> String {
        if value > 0.45{
            switch input {
            case "battery":
                return "Your photo was identified as a battery. Therefore, you should dispose of your item at an e-waste facility."
            case "biological":
                return "Your photo was identified as biological waste. Therefore, you should compost your item."
            case "cardboard":
                return "Your photo was identified as cardboard. Therefore, you should recycle your item."
            case "cement":
                return "Your photo was identified as cement. Therefore, it should be disposed of in construction waste."
            case "clothes":
                return "Your photo was identified as clothes. Therefore, you should donate them or dispose of them in a textile bin."
            case "electronics":
                return "Your photo was identified as electronics. Therefore, you should dispose of your item at an e-waste facility."
            case "glass":
                return "Your photo was identified as glass. Therefore, you should recycle your item."
            case "leather":
                return "Your photo was identified as leather. Consider donating it or using a special waste disposal service."
            case "metal":
                return "Your photo was identified as metal. Therefore, you should recycle your item."
            case "paper":
                return "Your photo was identified as paper. Therefore, you should recycle your item."
            case "plastic":
                return "Your photo was identified as plastic. Therefore, you should recycle it if it's recyclable or dispose of it properly."
            case "rubber":
                return "Your photo was identified as rubber. Consider taking it to a special recycling or disposal facility."
            case "trash":
                return "Your photo was identified as trash. Unfortunately, this should go to the landfill."
            case "wood":
                return "Your photo was identified as wood. It can often be recycled or repurposed, depending on its condition."
            default:
                return "Our percentage of accuracy is not high enough. We recommend that you try retaking the picture."
            }
        }
        else{
            return "Our percentage of accuracy is not high enough. We recommend that you retake the picture."
        }
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

