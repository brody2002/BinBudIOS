import SwiftUI

struct ContentView: View {
    @State var camera = CameraModel()
    @State private var navigateToCamera = false

    var body: some View {
        NavigationView {
            ZStack {
                Image("MindBlowing_design")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()
                    Logo()
                        .padding(.bottom, 300)
                        .padding(.trailing, 40)
                    Spacer()

                    // Automatically trigger navigation after a 2 second delay
                    NavigationLink(
                        destination: CameraView(camera: camera),
                        isActive: $navigateToCamera,
                        label: { EmptyView() }
                    )
                    .onAppear {
                        // Delay of 2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            camera.check() // Check camera
                            navigateToCamera = true
                        }
                    }
                }
            }
            .foregroundColor(AppColors.accentColor)
        }
    }
}

#Preview {
    ContentView()
}

