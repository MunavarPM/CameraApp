//
//  CameraService.swift
//  CameraApp
//
//  Created by MUNAVAR PM on 29/05/23.
//

import Foundation
import AVFoundation


class CameraService {
    
    // It was two service we nned to provide for our cameraService
    var session: AVCaptureSession?
    var delegate: AVCapturePhotoCaptureDelegate?
    
    let output = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    func start(delegate: AVCapturePhotoCaptureDelegate, completion: @escaping (Error?) -> ()) {
        self.delegate = delegate
        checkPremissions(completion: completion)
    }
    
    private func checkPremissions(completion: @escaping (Error?) -> ()) {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self?.setupCamera(completion: completion)
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera(completion: completion)
        @unknown default:
            break
        }
        
    }
    
    
    private func setupCamera(completion: @escaping (Error?) -> ()) {
        
        let session = AVCaptureSession()
        
        if let device = AVCaptureDevice.default(for: .video) {
            do {
               let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input){
                    session.addInput(input)
                }
                
                if session.canAddOutput(output){
                    session.addOutput(output)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                // Than we can start run the Session
                session.startRunning()
                self.session = session
                
                
            } catch  {
                completion(error)
            }
        }
        
    }
    
    func capturePhoto(with settings: AVCapturePhotoSettings = AVCapturePhotoSettings()) {
        output.capturePhoto(with: settings, delegate: delegate!)
    }
    
}


