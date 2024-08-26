import SwiftUI

struct CameraHelpToolbar: View {
    @Binding var showMenu: Bool
    @State private var backgroundOpacity = 0.8 // Starting Opacity
    @StateObject var camera = CameraModel()
    var body: some View {
        ZStack {
            Color(AppColors.settingsColor)
                .opacity(backgroundOpacity)
                .ignoresSafeArea()
            
            VStack {
                Spacer(minLength: 10)
                ZStack {
                    Text("How to Use")
                        .font(.title)
                        .bold()
                        .foregroundColor(AppColors.settingsColor)
                    HStack {
                        Spacer()
                        
                        CameraHelpBackButton(showMenu: $showMenu)
                            .padding(.trailing, 30)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    print("start running")
                                    camera.tempRun()
                                    print("toggle back")
                                    self.showMenu.toggle()
                                }
                            }
                    }
                }
                VStack {
                    Image(systemName: "photo")
                        .font(.system(size: 160))
                        .padding()
                    Image(systemName: "photo")
                        .font(.system(size: 160))
                        .padding()
                    Image(systemName: "photo")
                        .font(.system(size: 160))
                        .padding()
                }
                Spacer()
            }
        }
        .cornerRadius(50)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.1).delay(0.4)) {
                backgroundOpacity = 0.66
                // ending opacity
            }
        }
    }
}

#Preview {
    ZStack {
        CameraHelpToolbar(showMenu: .constant(true))
            .offset(y: 40)
    }
}

