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
                        Spacer(minLength: 50)
                        VStack(spacing: 20) { // Added spacing between the rectangles
                            
                            HStack (spacing: 15){
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 4) // Border color and width
                                        .frame(width: 170, height: 150)
                                    Text("Step 1:")
                                        .foregroundColor(.white)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                        .padding(.bottom,90)
                                    
                                    Text("Take a picture of trash with minimal backgrounds.")
                                        .foregroundColor(.white)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                        .frame(width: 150, height: 140)
                                        
                                }
                                
                                
                                Image("Take_a_photo")
                                    .resizable()
                                    .frame(width: 170, height: 150)
                                    .cornerRadius(10)
                            }
                            HStack (spacing: 15){
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 4) // Border color and width
                                        .frame(width: 170, height: 150)
                                    
                                    Text("Step 2:")
                                        .foregroundColor(.white)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                        .padding(.bottom,90)
                                    
                                    Text("BinBud will used it's classification model to identify your trash.")
                                        .foregroundColor(.white)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                        .frame(width: 150, height: 140)
                                        .padding(.top,25)
                                }
                                
                                
                                Image("Analyze")
                                    .resizable()
                                    .frame(width: 170, height: 150)
                                    .cornerRadius(10)
                            }
                            HStack(spacing: 15) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 4) // Border color and width
                                        .frame(width: 170, height: 150)
                                    
                                    Text("Step 3:")
                                        .foregroundColor(.white)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                        .padding(.bottom,90)
                                    
                                    Text("Dipose of your trash correctly!")
                                        .foregroundColor(.white)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                        .frame(width: 150, height: 140)
                                        .padding(.top,25)
                                }
                                
                                
                                Image("Trash")
                                    .resizable()
                                    .frame(width: 170, height: 150)
                                    .cornerRadius(10)
                            }
                            
                            
                            
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

