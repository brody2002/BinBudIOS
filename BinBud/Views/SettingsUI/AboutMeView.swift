import SwiftUI

struct AboutMeView: View {
    @State var camera = CameraModel()
    @State private var isVisible = true
    @State private var backgroundOpacity = 1.0 // Starting Opacity
    @State private var dragOffset = CGSize.zero // Track the drag offset
    @Binding var isAboutPress: Bool

    var body: some View {
        if isVisible {
            ZStack {
                Color(.white)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    Image("Icon")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.top,40)
                    
                    Text("BinBud")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .font(.system(size: 35))
                    
                    Link(destination: URL(string: "https://devpost.com/software/binbud")!) {
                        Text("https://devpost.com/software/binbud")
                            .tint(AppColors.cameraButtonColor)
                            .padding(.top, 20)
                            .font(.system(size: 16))
                            .underline()  // Ensure underline is applied
                    }

                        
                    
                    Text("Contact us:")
                        .foregroundColor(.black)
                        .padding(.top, 40)
                        .font(.system(size: 16))
                    
                    Link(destination: URL(string: "mailto:brodyroberts202@gmail.com")!){
                        Text("brodyroberts202@gmail.com")
                        .underline()
                        .tint(AppColors.cameraButtonColor)
                        .padding(.top, 1)
                        .font(.system(size: 16))
                    }
                        
                    
                    Text("San Francisco, Ca")
                        .padding(.top, 1)
                        .font(.system(size: 16))
                    
                    Spacer()
                        .padding(.bottom, 400)
                }
                // Ensure padding on the bottom to avoid clipping
            }
            .cornerRadius(10)
            .offset(y: self.dragOffset.height)
            .offset(y: 40) // Apply the drag offset to move the view
            .onAppear {
                withAnimation(.easeInOut(duration: 0.1)) {
                    backgroundOpacity = 0.99 // Ending opacity
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.height > 0 {
                            self.dragOffset = value.translation
                        }
                    }
                    .onEnded { value in
                        if value.translation.height > 200 {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                self.dragOffset.height = UIScreen.main.bounds.height
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                print("isAboutPress self \(self.isAboutPress)")
                                self.isVisible = false // Hide the view after dragging it off the screen
                                self.isAboutPress = false
                                self.dragOffset = .zero
                                
                                print("isVisible: \(isVisible)")
                                print("isAboutPress self \(self.isAboutPress)")
                            }
                        } else {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                self.dragOffset = .zero
                            }
                        }
                    }
            )
            .transition(.move(edge: .bottom))
        }
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        AboutMeView(isAboutPress: .constant(true))
    }
}

