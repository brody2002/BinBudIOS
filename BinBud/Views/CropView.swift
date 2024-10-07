//
//  CropView.swift
//  BinBud
//
//  Created by Brody on 10/7/24.
//

import SwiftUI
// Circles
struct CroppingCircle: View {
    @Binding var point: CGPoint // Binding to accept offset from parent
    @Binding var dragPoint: CGPoint // Bind the drag offset from parent

    var body: some View {
        Circle()
            .fill(Color.black)
            .frame(width: 20, height: 20)
            .offset(x: point.x + dragPoint.x, y: point.y + dragPoint.y)
            .gesture(
                DragGesture()
                    .onChanged { value in
                                            dragPoint = CGPoint(x: value.translation.width, y: value.translation.height)
                                        }
                    .onEnded { _ in
                        point.x += dragPoint.x
                        point.y += dragPoint.y
                        dragPoint = .zero
                    }
            )
    }
}



// Handles the Boundaries
struct BoundsView: View {
    @Binding var showCroppedImage: Bool
    @Binding var finalCroppedImage: UIImage?
    
    @State private var points: [CGPoint] = [
        CGPoint(x: -100, y: -100), // L top Corner
        CGPoint(x: 100, y: -100),  // R top corner
        CGPoint(x: 100, y: 100),   // R bot corner
        CGPoint(x: -100, y: 100)   // L bot corner
    ]
    @State private var dragPoints: [CGPoint]

    init(finalCroppedImage: Binding<UIImage?>, showCroppedImage: Binding<Bool>) {
        _finalCroppedImage = finalCroppedImage
        _showCroppedImage = showCroppedImage
        _dragPoints = State(initialValue: Array(repeating: .zero, count: 4))
    }
    
    private var pathOffsetX: CGFloat = 200
    private var pathOffsetY: CGFloat = 200

    private func getCroppingRectangle() -> CGRect {
        let dictPoints = points.enumerated().map { (index, offset) in
            CGPoint(x: offset.x + dragPoints[index].x + pathOffsetX,
                    y: offset.y + dragPoints[index].y + pathOffsetY)
        }

        // Calculate the min and max X and Y values
        let minX = dictPoints.map { $0.x }.min() ?? 0
        let maxX = dictPoints.map { $0.x }.max() ?? 0
        let minY = dictPoints.map { $0.y }.min() ?? 0
        let maxY = dictPoints.map { $0.y }.max() ?? 0

        // Adjust minX and minY only for the first point (top left corner)
//        let adjustedMinX = minX + 100
//        let adjustedMinY = minY + 100
        var toAdjust = CGRect(x: minX, y: minY + 250.0, width: maxX - minX, height: maxY - minY)
        print(toAdjust)
        
        return toAdjust
    }
    
    var body: some View {
        ZStack {
            // Place circles
            ForEach(0..<points.count, id: \.self) { index in
                CroppingCircle(point: $points[index], dragPoint: $dragPoints[index])
            }
            
            // Draw lines between neighboring circles
            ForEach(0..<points.count, id: \.self) { index in
                let point1 = points[index]
                let point2 = points[(index + 1) % points.count] // Connect back to the first circle
                
                // Calculate the center points of each circle
                let p1 = CGPoint(x: point1.x + pathOffsetX + dragPoints[index].x, y: point1.y + pathOffsetY + dragPoints[index].y)
                let p2 = CGPoint(x: point2.x + pathOffsetX + dragPoints[(index + 1) % points.count].x, y: point2.y + pathOffsetY + dragPoints[(index + 1) % points.count].y)
                
                // Create a path for each line
                Path { path in
                    path.move(to: p1)
                    path.addLine(to: p2)
                }
                .stroke(Color.blue, lineWidth: 2)
            }
            
            Button(action: {
                print("cropping IMAGE")
                let output = getCroppingRectangle()
                print("output \(output)")
                
                if let snapshotImage = UIApplication.shared.windows.first?.rootViewController?.view.snapshot(of: output) {
                    finalCroppedImage = snapshotImage
                    showCroppedImage = true // Update state to show the cropped image
                }
                
            }, label: {
                Text("Crop Image")
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(5)
//                    .padding(.bottom, 400)
            })
        }
    }
}

// Main View
struct CropView: View {
    @State private var showCroppedImage: Bool = false
    @State private var finalCroppedImage: UIImage? = nil // Store the cropped image
    
    var body: some View {
        VStack {
            if showCroppedImage, let finalCroppedImage = finalCroppedImage {
                // Show cropped image
                Image(uiImage: finalCroppedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 400) // Adjust the height as needed
                    .border(Color.black, width: 2)
            } else {
                // Show original image
                Image("download")
                    .resizable()
                    .scaledToFit()
                    .overlay {
                        BoundsView(finalCroppedImage: $finalCroppedImage, showCroppedImage: $showCroppedImage)
                    }
            }
        }
    }
}


#Preview {
    CropView()
}

extension UIView {
    func snapshot(of rect: CGRect) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { context in
            self.layer.render(in: context.cgContext)
        }
    }
}
