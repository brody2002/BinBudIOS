import SwiftUI

struct CameraModelOutputView: View {
    @State var isShowing: Bool = true
    @State var modelOutput : String
    @State var modelInstructions : String
    @State var modelConfidence : Double
    var body: some View {
//        if isShowing {
            ZStack {
                VStack {
                    Text("The Object has been identified as")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .bold()
                    Text("Item: \(self.modelOutput)")
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                        .bold()
                        .padding(.top, 4)
                    Text("\(String(format: "Confidence Score: %.2f", self.modelConfidence))")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .bold()
                        .padding(.top, 4)
                    Text("\(self.modelInstructions)")
                        .foregroundColor(AppColors.cameraButtonColor)
                        .padding(.top, 20)
                        .font(.system(size: 18))
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.leading,60)
                        .padding(.trailing,60)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 60, style: .continuous)
                    .fill(AppColors.settingsColor)
                    .frame(width: 300, height: 290)
                    
            )
            .padding(.bottom,50)
//        }
    }
}

#Preview {
    CameraModelOutputView(modelOutput: "Paper",modelInstructions: "Your waste material is battery. Therefore, you should dispose of it at an e-waste facility.",modelConfidence: 0.66)
}

