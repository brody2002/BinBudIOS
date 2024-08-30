import SwiftUI

struct CameraModelOutputView: View {
    @State var isShowing: Bool = true
    @State var modelOutput : String
    var body: some View {
//        if isShowing {
            ZStack {
                VStack {
                    Text("The Object has been identified as")
                        .foregroundColor(.white)
                        .font(.system(size: 13))
                        .bold()
                    Text("Item: \(self.modelOutput)!")
                        .foregroundColor(.white)
                        .font(.system(size: 13))
                        .bold()
                        .padding(.top, 4)
                    Text("Instructions PlaceHolder")
                        .foregroundColor(AppColors.cameraButtonColor)
                        .padding(.top, 3)
                        .bold()
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 60, style: .continuous)
                    .fill(AppColors.settingsColor)
                    .frame(width: 300, height: 160)
            )
//        }
    }
}

#Preview {
    CameraModelOutputView(modelOutput: "Paper")
}

