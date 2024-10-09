//
//  CropView.swift
//  BinBud
//
//  Created by Brody on 10/7/24.
//
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
                        // Adjust smoothly with value translation
                        dragPoint = CGPoint(x: value.translation.width, y: value.translation.height)
                    }
                    .onEnded { _ in
                        // Update the main point with the drag offset once dragging ends
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
        CGPoint(x: -100, y: -300), // L top Corner
        CGPoint(x: 100, y: -300),  // R top corner
        CGPoint(x: 100, y: 100),   // R bot corner
        CGPoint(x: -100, y: 100)   // L bot corner
    ]
    @State private var dragPoints: [CGPoint]
    @State private var hideElements: Bool = false

    init(finalCroppedImage: Binding<UIImage?>, showCroppedImage: Binding<Bool>) {
        _finalCroppedImage = finalCroppedImage
        _showCroppedImage = showCroppedImage
        _dragPoints = State(initialValue: Array(repeating: .zero, count: 4))
    }
    
    private var pathOffsetX: CGFloat = 195
    private var pathOffsetY: CGFloat = 422.5

    // Function to get the cropping path
    private func getCroppingPath() -> Path {
        Path { path in
            // Start at the first point
            let firstPoint = CGPoint(
                x: points[0].x + dragPoints[0].x + pathOffsetX,
                y: points[0].y + dragPoints[0].y + pathOffsetY
            )
            path.move(to: firstPoint)
            
            // Draw lines to each of the other points
            for index in 1..<points.count {
                let point = CGPoint(
                    x: points[index].x + dragPoints[index].x + pathOffsetX,
                    y: points[index].y + dragPoints[index].y + pathOffsetY
                )
                path.addLine(to: point)
            }
            
            path.closeSubpath()
        }
    }

    // Function to get the cropping rectangle with intentional offset adjustment
    private func getCroppingRectangle() -> CGRect {
        // Calculate the actual positions of the points including drag offset
        let adjustedPoints = points.enumerated().map { (index, point) in
            CGPoint(x: point.x + dragPoints[index].x + pathOffsetX,
                    y: point.y + dragPoints[index].y + pathOffsetY)
        }

        // Calculate the min and max X and Y values to create the bounding rectangle
        let minX = adjustedPoints.map { $0.x }.min() ?? 0
        let maxX = adjustedPoints.map { $0.x }.max() ?? 0
        let minY = adjustedPoints.map { $0.y }.min() ?? 0
        let maxY = adjustedPoints.map { $0.y }.max() ?? 0

        // Return the CGRect representing the bounding box for the cropping area, with intentional offset
        
        // Cropping Rectangle
        return CGRect(x: minX, y: minY + 0, width: maxX - minX, height: maxY - minY)
    }

    var body: some View {
        ZStack {
            // Draw the gray overlay with the cropping path cut out
            GeometryReader { geometry in
                let cropPath = getCroppingPath()
                
                // Show the gray overlay only if not hiding elements
                if !hideElements {
                    Rectangle()
                        .fill(Color.gray.opacity(0.8))
                        .mask(
                            // Inverse the mask by subtracting the cropPath
                            Rectangle()
                                .path(in: CGRect(origin: .zero, size: geometry.size))
                                .subtracting(cropPath)
                        )
                        
                }
            }
            
            // Place circles and lines if not hidden
            if !hideElements {
                // Place circles
                ForEach(0..<points.count, id: \.self) { index in
                    CroppingCircle(point: $points[index], dragPoint: $dragPoints[index]).zIndex(2.0)
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
                    .stroke(AppColors.cameraButtonColor, lineWidth: 3).zIndex(1.0)
                }
                
                // Crop Button
                Button(action: {
                    // Hide elements before capturing screenshot
                    hideElements = true
                    
                    // Delay the screenshot by 0.2 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        let output = getCroppingRectangle()
                        print("output \(output)")
                        
                        // Capture the screenshot
                        if let snapshotImage = UIApplication.shared.windows.first?.rootViewController?.view.snapshot(of: output) {
                            finalCroppedImage = snapshotImage
                            showCroppedImage = true // Update state to show the cropped image
                        }
                        
                        // Show elements again after taking the screenshot
                        hideElements = false
                    }
                }, label: {
                    Text("Crop Image")
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .padding(.top, 300)
                })
            }
        }.ignoresSafeArea()
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

// Preview
#Preview {
    CropView()
}

// Extension for taking snapshot of a UIView
extension UIView {
    func snapshot(of rect: CGRect) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { context in
            self.layer.render(in: context.cgContext)
        }
    }
}

