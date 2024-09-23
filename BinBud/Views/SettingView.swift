import SwiftUI

struct SettingsView: View {
    @Binding var showSettings: Bool
    @Binding var hideCameraUI: Bool
    @State private var isVisible = true
    @State private var isDiscordHold = false
    @State private var isAboutHold = false
    @State private var isAboutPress = false
    @State private var dragOffset = CGSize.zero

    var body: some View {
        
        ZStack {
            if isVisible {
                GeometryReader { geometry in
                    VStack(alignment: .leading) {
                        HStack {
                            Text("BinBud")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.leading, 0)
                                .padding(.top, 40)
                                .foregroundColor(AppColors.settingsColor)
                        }
                        .padding(.leading, 20)
                        .padding(.top, 20)

                        Divider()
                            .padding(.vertical, 0)

                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Image(systemName: "info.circle")
                                    .foregroundColor(isAboutHold ? Color.black.opacity(0.3) : Color.black)
                                Text("About us")
                                    .foregroundColor(isAboutHold ? Color.black.opacity(0.3) : Color.black)
                            }
                            .onTapGesture {
                                self.isAboutPress.toggle()                       }
                            .onLongPressGesture(minimumDuration: 3, pressing: { isPressing in
                                    withAnimation(.easeInOut(duration: 0.5)){
                                        self.isAboutHold = isPressing
                                    }
                                }, perform: {
                                    
                                }
                            ).transition(.move(edge: .top))
                            
                            HStack {
                                Image("discordIcon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 17, height: 17)
                                    .foregroundColor(isDiscordHold ? AppColors.cameraButtonColor.opacity(0.3) : AppColors.cameraButtonColor)
                                    
                            
                                Text("Discord")
                                    .foregroundColor(isDiscordHold ? AppColors.cameraButtonColor.opacity(0.3) : AppColors.cameraButtonColor)
                                    .font(.system(size: 18, weight: .bold))
                            }
                            .padding(.leading, 2)
                            .onTapGesture {
                                if let url = URL(string: "https://discord.gg/tfmjWwwrsk") {
                                                        UIApplication.shared.open(url)
                                                    }
                            }
                            .onLongPressGesture(minimumDuration: 3, pressing: { isPressing in
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                                        self.isDiscordHold = isPressing
                                    }
                                }, perform: {
                                    
                                }
                            )
                            
                            
                        }
                        .padding(.leading, 20)
                        .padding(.top, 20)
                        
                        Spacer()
                    }
                    .frame(width: geometry.size.width * 0.75) // Set the width to 3/4 of the screen width
                    .frame(maxHeight: .infinity)
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.all)
                    .offset(x: self.dragOffset.width) // Apply the drag offset here
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if value.translation.width < 0 {
                                    // Clamp the value here to avoid large negative values
                                    self.dragOffset = CGSize(width: max(value.translation.width, -UIScreen.main.bounds.width), height: 0)
                                }
                            }
                            .onEnded { gesture in
                                if gesture.translation.width < -60 {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                                        self.dragOffset.width = -UIScreen.main.bounds.width
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            self.hideCameraUI = false
                                            self.showSettings = false
                                        }
                                    }
                                } else {
                                    withAnimation {
                                        self.dragOffset = .zero
                                    }
                                }
                            }
                    )
                }
                .transition(.move(edge: .leading))
            }
            if isAboutPress {
                            AboutMeView(isAboutPress: $isAboutPress)
                                .transition(.move(edge: .bottom)) // Animate from bottom to top
                        }
        }
            .animation(.spring(response: 0.3, dampingFraction: 0.9), value: isAboutPress)
        
    }
    
}

#Preview {
    ZStack {
        Color(AppColors.settingsColor.opacity(0.5)).ignoresSafeArea()
        SettingsView(showSettings: .constant(true), hideCameraUI: .constant(true))
    }
}

