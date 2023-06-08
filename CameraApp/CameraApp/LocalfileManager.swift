//
//  LocalfileManager.swift
//  CameraApp
//
//  Created by MUNAVAR PM on 30/05/23.
//

import SwiftUI


class LocalFileManager {
    
    // SingleTon
    static let instance = LocalFileManager()
    private init (){ }
        
    func saveImage(image : UIImage,imageName : String, folderName: String){
        createFolderIfNeeded(folderName: folderName)
        guard
            let data = image.jpegData(compressionQuality: 1),
            let url = getURLForImage(imageName: imageName, folderName: folderName)
            else { return }
        do {
            
            try data.write(to: url) //write the image data to url by this writing method and while writing it has any error than print that.
        } catch let error {
            print("Error saving image. Error \(error)")
        }
    }
    
    func getImage(imageName : String, folderName: String)-> UIImage?{
        guard let url = getURLForImage(imageName: imageName, folderName: folderName),
        FileManager.default.fileExists(atPath: url.path)
        else { return nil }
        return UIImage(contentsOfFile: url.path)
        
            
    }
    // 2
    private func createFolderIfNeeded (folderName : String) {
        guard let url = getURLFolder(folderName: folderName) else { return }
        // Check that the file was exicits or not. If it not then next step
        if !FileManager.default.fileExists(atPath: url.path){
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch let error {
                print("Error \(error)")
            }
        }
    }
    // 1
    private func getURLFolder(folderName: String)-> URL? {
        // userDomainMask = user Home Dictionary
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        return url.appendingPathComponent(folderName)
    }
    // 3 . We need to convert the image into URL while we are saving.
    private func getURLForImage(imageName:String, folderName:String)-> URL? {
        guard let folderURL = getURLFolder(folderName: folderName) else { return nil }
        return folderURL.appending(component: imageName )
    }
}


