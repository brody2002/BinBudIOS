import SwiftUI

struct SettingsView: View {
    @Binding var showSettings: Bool
    @State private var isVisible = true
    @State private var dragOffset = CGSize.zero

    var body: some View {
        ZStack {
            if isVisible {
                GeometryReader { geometry in
                    VStack(alignment: .leading) {
                        HStack {
                            Text("BINBUD")
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
                                Text("About us")
                            }
                            
                            HStack {
                                Image("discordIcon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 17, height: 17)
                                    .foregroundColor(AppColors.cameraButtonColor)
                            
                                Text("Discord")
                                    .foregroundColor(AppColors.cameraButtonColor)
                                    .font(.system(size: 18, weight: .bold))
                            }
                            .padding(.leading, 2)
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
//                                    print("checking location of drag continuously")
                                    self.dragOffset = value.translation
                                }
                            }
                            .onEnded { value in
                                if value.translation.width < -50 { // Swipe left sufficiently
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        self.dragOffset = CGSize(width: -geometry.size.width, height: 0)
                                        isVisible = false
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        self.showSettings = false
                                    }
                                } else { // Snap back to original position
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        self.dragOffset = .zero
                                    }
                                }
                            }
                    )
                }
                .transition(.move(edge: .leading))
            }
        }
    }
}

#Preview {
    ZStack {
        Color(AppColors.settingsColor.opacity(0.5)).ignoresSafeArea()
        SettingsView(showSettings: .constant(true))
    }
}

