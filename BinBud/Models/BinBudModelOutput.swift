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
    
    // Add any other necessary logic here
}

