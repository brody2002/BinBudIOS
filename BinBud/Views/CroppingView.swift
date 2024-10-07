////
////  CroppingView.swift
////  BinBud
////
////  Created by Brody on 10/7/24.
////
//
//import SwiftUI
//
//struct CroppingCircle: View {
//    @Binding var offset: CGSize // Binding to accept offset from parent
//    @Binding var dragOffset: CGSize // Bind the drag offset from parent
//
//    var body: some View {
//        Circle()
//            .fill(Color.green)
//            .frame(width: 20, height: 20)
//            .offset(x: offset.width + dragOffset.width, y: offset.height + dragOffset.height)
//            .gesture(
//                DragGesture()
//                    .onChanged { value in
//                        dragOffset = value.translation
//                    }
//                    .onEnded { _ in
//                        offset.width += dragOffset.width
//                        offset.height += dragOffset.height
//                        dragOffset = .zero
//                    }
//            )
//    }
//}
//
//struct CropGrabberControl: View {
//    
//    
//    @Binding var topLeft: CGPoint
//    @Binding var topRight: CGPoint
//    @Binding var bottomRight: CGPoint
//    @Binding var bottomLeft: CGPoint
//    
//    var body: some View {
////        ImageRenderer
//        Text("HI")
//        Text("\(topLeft) \(topRight) \(bottomRight), \(bottomLeft)")
//            .offset(y:130)
//    }
//}
//
//struct ImageView: View {
//    
//    
//    
//    // Circle Coordinates:
//    @State private var offsets: [CGSize] = [
//        CGSize(width: -100, height: -100), // L top Corner
//        CGSize(width: 100, height: -100),  // R top corner
//        CGSize(width: 100, height: 100),   // R bot corner
//        CGSize(width: -100, height: 100)   // L bot corner
//    ]
//    @State private var dragOffsets: [CGSize]
//    @State private var croppingRectangle: CGRect = .zero // State to store the cropping rectangle
//    @State private var snapShot: UIImage? = nil // Store the screenshot of the cropped area
//    
//    @State var topLeft: CGPoint = .zero
//    @State var topRight: CGPoint = .zero
//    @State var bottomRight: CGPoint = .zero
//    @State var bottomLeft: CGPoint = .zero
//    
//    init() {
//        // Initialize dragOffsets with the same size as offsets
//        _dragOffsets = State(initialValue: Array(repeating: CGSize.zero, count: 4))
//    }
//
//    
//    
//    private func getCroppingRectangle() -> CGRect {
//        // Get all the points based on offsets and dragOffsets
//        print("offsets: \(offsets)")
//        let points = offsets.enumerated().map { (index, offset) in
//            CGPoint(x: offset.width + dragOffsets[index].width + 185,
//                    y: offset.height + dragOffsets[index].height + 185)
//        }
//        print("points \(points)")
//        // Calculate the minimum and maximum x and y values to form a rectangle
//        let minX = points.map { $0.x }.min() ?? 0
//        let maxX = points.map { $0.x }.max() ?? 0
//        let minY = points.map { $0.y }.min() ?? 0
//        let maxY = points.map { $0.y }.max() ?? 0
//
//        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
//    }
//    
//
//    var body: some View {
//        ZStack{
//            ScrollView {
//                VStack {
//                    ZStack {
//                        
//                        Image("download")
//                            .resizable()
//                            .scaledToFit()
//                            .overlay(
//                                Rectangle()
//                                    .stroke(Color.red, lineWidth: 2)
//                                    .frame(width: croppingRectangle.width, height: croppingRectangle.height)
//                                    .position(x: croppingRectangle.midX, y: croppingRectangle.midY)
//                                    .opacity(croppingRectangle == .zero ? 0 : 1)
//                            )
//                            .overlay {
//                                Color.red.opacity(0.5)
//                                CropGrabberControl(
//                                    topLeft: $topLeft,
//                                    topRight: $topRight,
//                                    bottomRight: $bottomRight,
//                                    bottomLeft: $bottomLeft
//                                )
//                            }
//    
//                            .background(Color.red)
//                        
//                        // Draw lines between neighboring circles
//                        ForEach(0..<offsets.count, id: \.self) { index in
//                            let offset1 = offsets[index]
//                            let offset2 = offsets[(index + 1) % offsets.count] // Connect back to the first circle
//                            
//                            // Calculate the center points of each circle
//                            let point1 = CGPoint(x: offset1.width + 185 + dragOffsets[index].width, y: offset1.height + 185 + dragOffsets[index].height)
//                            let point2 = CGPoint(x: offset2.width + 185 + dragOffsets[(index + 1) % offsets.count].width, y: offset2.height + 185 + dragOffsets[(index + 1) % offsets.count].height)
//                            
//                            // Create a path for each line
//                            Path { path in
//                                path.move(to: point1)
//                                path.addLine(to: point2)
//                            }
//                            .stroke(Color.green, lineWidth: 2)
//                        }
//                        
//                        // Draw circles
//                        ForEach(0..<offsets.count, id: \.self) { index in
//                            CroppingCircle(offset: $offsets[index], dragOffset: $dragOffsets[index]) // Bind the offset and dragOffset for each circle
//                        }
//                        
//                        
//                    }
//                    .padding()
//                    
//                    Button(action: {
//                        croppingRectangle = getCroppingRectangle()
//                        
//                        if let snapshotImage = UIApplication.shared.windows.first?.rootViewController?.view.snapshot(of: croppingRectangle) {
//                            snapShot = snapshotImage
//                        }
//                    }, label: {
//                        Text("Capture Screenshot")
//                            .padding()
//                            .background(Color.black)
//                            .foregroundColor(.white)
//                            .cornerRadius(5)
//                    })
//                    .padding()
//                    
//                    // Show cropped image
//                    if let snapShot = snapShot {
//                        Image(uiImage: snapShot)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(height: 200)
//                            .border(Color.black, width: 2)
//                    }
//                }
//            }
//           
//        }
//        
//        
//    }
//    
//    
//}
//
//#Preview {
//    ImageView()
//}
//
//extension UIView {
//    func snapshot(of rect: CGRect) -> UIImage? {
//        let renderer = UIGraphicsImageRenderer(bounds: rect)
//        return renderer.image { context in
//            self.layer.render(in: context.cgContext)
//        }
//    }
//}
//
