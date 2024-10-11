import SwiftUI
import AVFoundation

// Circles and Lines View
struct CircleBoundaryView: View {
    @Binding var points: [CGPoint]

    var body: some View {
        GeometryReader { geometry in
            let containerSize = geometry.size

            ZStack {
                // Draw lines between neighboring circles
                Path { path in
                    for index in points.indices {
                        let point1 = CGPoint(
                            x: points[index].x + containerSize.width / 2,
                            y: points[index].y + containerSize.height / 2
                        )
                        let point2 = CGPoint(
                            x: points[(index + 1) % points.count].x + containerSize.width / 2,
                            y: points[(index + 1) % points.count].y + containerSize.height / 2
                        )

                        if index == 0 {
                            path.move(to: point1)
                        }
                        path.addLine(to: point2)
                    }
                }
                .stroke(Color.black, lineWidth: 3)
                .zIndex(1.0)

                // Place circles
                ForEach(points.indices, id: \.self) { index in
                    let adjustedPoint = CGPoint(
                        x: points[index].x + containerSize.width / 2,
                        y: points[index].y + containerSize.height / 2
                    )

                    CroppingCircle(point: $points[index])
                        .position(adjustedPoint)
                        .zIndex(2.0)
                }
            }
        }
    }
}

// Circles
struct CroppingCircle: View {
    @Binding var point: CGPoint

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.black)
                .frame(width: 20, height: 20)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            // Directly update the point during drag to make it smoother
                            point.x += value.translation.width
                            point.y += value.translation.height
                        }
                )
        }
    }
}

// Handles the Boundaries
struct BoundsView: View {
    @Binding var showCroppedImage: Bool
    @Binding var finalCroppedImage: UIImage?
    @Binding var isCropping: Bool

    @State private var points: [CGPoint] = [
        CGPoint(x: -100, y: -300), // L top Corner
        CGPoint(x: 100, y: -300),  // R top corner
        CGPoint(x: 100, y: 100),   // R bot corner
        CGPoint(x: -100, y: 100)   // L bot corner
    ]
    @State private var hideElements: Bool = false

    init(finalCroppedImage: Binding<UIImage?>, showCroppedImage: Binding<Bool>, isCropping: Binding<Bool>) {
        _finalCroppedImage = finalCroppedImage
        _showCroppedImage = showCroppedImage
        _isCropping = isCropping
    }

    // Function to get the cropping rectangle
    private func getCroppingRectangle(containerSize: CGSize) -> CGRect {
        // Calculate the actual positions of the points including their adjustments
        let adjustedPoints = points.map {
            CGPoint(
                x: $0.x + containerSize.width / 2,
                y: $0.y + containerSize.height / 2
            )
        }

        // Calculate the min and max X and Y values to create the bounding rectangle
        let minX = adjustedPoints.map { $0.x }.min() ?? 0
        let maxX = adjustedPoints.map { $0.x }.max() ?? 0
        let minY = adjustedPoints.map { $0.y }.min() ?? 0
        let maxY = adjustedPoints.map { $0.y }.max() ?? 0

        // Return the CGRect representing the bounding box for the cropping area
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }

    var body: some View {
        GeometryReader { geometry in
            let containerSize = geometry.size

            ZStack {
                // Draw the gray overlay with the cropping path cut out
                if !hideElements {
                    let cropPath = Path { path in
                        let adjustedPoints = points.map {
                            CGPoint(
                                x: $0.x + containerSize.width / 2,
                                y: $0.y + containerSize.height / 2
                            )
                        }

                        path.move(to: adjustedPoints[0])
                        for index in 1..<adjustedPoints.count {
                            path.addLine(to: adjustedPoints[index])
                        }
                        path.closeSubpath()
                    }

                    Rectangle()
                        .fill(Color.black.opacity(0.6))
                        .mask(
                            // Inverse the mask by subtracting the cropPath
                            Rectangle()
                                .path(in: CGRect(origin: .zero, size: containerSize))
                                .subtracting(cropPath)
                        )
                }

                // Place circles and lines if not hidden
                if !hideElements {
                    CircleBoundaryView(points: $points)
                        .zIndex(2.0)
                }
            }
            .onChange(of: isCropping) { newValue in
                if newValue {
                    hideElements = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        let output = getCroppingRectangle(containerSize: containerSize)
                        print("output \(output)")

                        // Capture snapshot
                        if let snapshotImage = UIApplication.shared.windows.first?.rootViewController?.view.snapshot(rect: output) {
                            finalCroppedImage = snapshotImage
                            showCroppedImage = true
                        }
                        hideElements = false
                        isCropping = false
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

// Main View
struct testView: View {
    @State private var showCroppedImage: Bool = false
    @State private var finalCroppedImage: UIImage? = nil // Store the cropped image
    @State private var isCropping: Bool = false
    var body: some View {
        ZStack {
            Text("testButton")
                .padding()
                .cornerRadius(50)
                .background(Color.red)
                .onTapGesture {
                    print("test crop")
                    isCropping = true
                }
                .padding(.bottom, 300)
                .zIndex(3.0)
            
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
                            BoundsView(finalCroppedImage: $finalCroppedImage, showCroppedImage: $showCroppedImage, isCropping: $isCropping)
                        }
                }
            }
        }
    }
}

//#Preview {
//    testView()
//}


struct CropView: View {
    @State private var showCroppedImage: Bool = false
    @State private var finalCroppedImage: UIImage? = nil // Store the cropped image
    @State private var isCropping: Bool = false
    
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
                        BoundsView(finalCroppedImage: $finalCroppedImage, showCroppedImage: $showCroppedImage,isCropping: $isCropping)
                    }
            }
        }
    }
}

// Preview
#Preview {
    CropView()
}
// Extension to capture a snapshot of a UIView using the frame specified
extension UIView {
    func snapshot(rect: CGRect) -> UIImage? {
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        let renderer = UIGraphicsImageRenderer(bounds: rect, format: format)
        return renderer.image { context in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
    }
}

