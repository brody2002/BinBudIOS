import SwiftUI

struct CameraHelpToolbar: View {
    @Binding var showMenu: Bool
    @State var camera = CameraModel()
    @State private var backgroundOpacity = 1.0 // Starting Opacity
    var body: some View {
        ZStack {
            Color(AppColors.settingsBackground)
                .opacity(backgroundOpacity)
                .ignoresSafeArea()
            
            VStack {
                Spacer(minLength: 20)
                ZStack {
                        HStack{
                            Text("How to Use")
                                .font(.system(size: 36))
                                .bold()
                                .foregroundColor(AppColors.settingsColor)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        
                    }.padding(.leading, 20)
                    HStack {
                        Spacer()
                        
                        CameraHelpBackButton(showMenu: $showMenu)
                            .padding(.trailing, 30)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    print("toggle back")
                                    self.showMenu.toggle()
                                    
                                }
                            }
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
        .onAppear {
            withAnimation(.easeInOut(duration: 0.1)) {
                backgroundOpacity = 0.95
                // ending opacity
            }
        }
    }
}

#Preview {
    ZStack {
        CameraHelpToolbar(showMenu: .constant(true))
            .offset(y: 20)
    }
}

