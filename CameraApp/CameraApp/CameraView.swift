//
//  CameraView.swift
//  CameraApp
//
//  Created by MUNAVAR PM on 29/05/23.
//

import SwiftUI
import AVFoundation


struct CameraView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    // Here we implemented the cameraService outside of the cameraView becaouse we need some custom the button like thinks
    let cameraService: CameraService
    //result type for catch the success and fail.
    let didFinishProcessingPhoto: (Result<AVCapturePhoto,Error>) -> ()
    
    // create and configure and retrun the view
    func makeUIViewController(context: Context) -> UIViewController {
        
        // we want to our camera service 
        cameraService.start(delegate: context.coordinator) { error in
            if let error = error {
                didFinishProcessingPhoto(.failure(error))
                return
            }
        }
        
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black
        viewController.view.layer.addSublayer(cameraService.previewLayer)
        cameraService.previewLayer.frame = viewController.view.bounds
        return viewController
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, didFinishProcessingPhoto: didFinishProcessingPhoto)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {  }
    
    class Coordinator: NSObject,AVCapturePhotoCaptureDelegate {
        let parent: CameraView
        private var didFinishProcessingPhoto: (Result<AVCapturePhoto,Error>) -> ()
        
        init(parent: CameraView, didFinishProcessingPhoto: @escaping (Result<AVCapturePhoto,Error>) -> ()) {
            self.parent = parent
            self.didFinishProcessingPhoto = didFinishProcessingPhoto
            
        }
        // Next the delegateMethod
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?){
            if let error = error {
                didFinishProcessingPhoto(.failure(error))
                return
            }
            didFinishProcessingPhoto(.success(photo))
        }
    }
}
