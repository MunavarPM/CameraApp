//
//  CustomCameraView.swift
//  CameraApp
//
//  Created by MUNAVAR PM on 29/05/23.
//

import SwiftUI


struct CustomCameraView: View {
    
    let cameraServce = CameraService()
    /// We want the capture image in contentView for that we "@" than the state variabel update image from customeCamera to contentView
        let fileManager = LocalFileManager.instance
        let folderName = "CaptureImages"
        let cameraService = CameraService()
        @State var capturedImage : UIImage?
        @State var retreviedImage : UIImage?
        @Binding var images : [UIImage]
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        ZStack {
            CameraView(cameraService: cameraServce) { result in
                switch result {
                    
                case .success(let photo):
                    if let data = photo.fileDataRepresentation() {
                        capturedImage = UIImage(data: data)
                        presentationMode.wrappedValue.dismiss()

                        
                        fileManager.saveImage(image: capturedImage!, imageName: capturedImage!.description, folderName: folderName)
                        //then retreving the image that was capture
                        retreviedImage = fileManager.getImage(imageName: capturedImage!.description, folderName: folderName)
                        
                        if let retreviedImage = retreviedImage {
                            images.append(retreviedImage)
                            
                        }
                        else{
                            print("error")
                        }
                        
                        
                    }
                    
                 else {
                        print("Error : No image Founded")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            VStack {
                Spacer()
                
                Button(action: {
                    cameraServce.capturePhoto()
                }, label: {
                    Image(systemName: "circle")
                        .font(.system(size: 72))
                        .foregroundColor(.white)
                })
                .padding(.bottom)
            }
        }
    }
    
    
}
