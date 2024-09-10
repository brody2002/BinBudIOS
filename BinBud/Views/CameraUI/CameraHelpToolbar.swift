import SwiftUI

struct CameraHelpToolbar: View {
    @Binding var showHelpMenu: Bool
    
    @State var camera = CameraModel()
    @State private var isVisible = true
    @State private var backgroundOpacity = 1.0 // Starting Opacity
    @State private var dragOffset = CGSize.zero // Track the drag offset
    
    var body: some View {
        if isVisible {
            ZStack {
                Color(.clear)
                    .opacity(backgroundOpacity)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer(minLength: 20)
                    ZStack {
                        HStack{
                            Text("How to Use")
                                .font(.system(size: 50))
                                .bold()
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            
                        }.padding(.leading, 20)
                        HStack {
                            Spacer()
                            
                            CameraHelpBackButton(showHelpMenu: $showHelpMenu)
                                .padding(.trailing, 30)
                                
                        }
                    }
                    ScrollView {
                        VStack(spacing: 20) { // Added spacing between the rectangles
                            
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundColor(.white)
                                .frame(width: 340, height: 300)
                            
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundColor(.white)
                                .frame(width: 340, height: 300)
                            
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundColor(.white)
                                .frame(width: 340, height: 300)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                    Spacer()
                }
            }
            .cornerRadius(50)
            .offset(y: self.dragOffset.height) // Apply the drag offset to move the view
            .onAppear {
                withAnimation(.easeInOut(duration: 0.1)) {
                    backgroundOpacity = 0.95 // ending opacity
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
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                                self.dragOffset.height = UIScreen.main.bounds.height
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation{
                                    self.showHelpMenu.toggle()
                                    self.dragOffset = .zero
                                }
                                
                            }
                        } else {
                            withAnimation{
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
        Color.red
        CameraHelpToolbar(showHelpMenu: .constant(true))
            .offset(y: 30)
    }
}

