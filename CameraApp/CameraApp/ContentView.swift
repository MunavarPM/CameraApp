import SwiftUI

struct ContentView: View {
    
    
    @State private var isCustomCameraViewPresented = false
    @State  var images : [UIImage] = []
    let coloumn = [GridItem(.adaptive(minimum: 60))]
    
    
    
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            ScrollView {
                
                LazyVGrid(columns: coloumn, spacing: 1){
                        ForEach(images, id: \.self){ image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width:100.0, height: 100.0)
                    }
                }
            }
            .padding(.all)

            
            VStack {
                Spacer()
                Button(action: {
                    isCustomCameraViewPresented.toggle()
                }, label: {
                    Image(systemName: "camera.fill")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                })
                .padding(.bottom)
                .sheet(isPresented: $isCustomCameraViewPresented, content: {
                    CustomCameraView(images: $images)
                })
            }
        }
    }
}
