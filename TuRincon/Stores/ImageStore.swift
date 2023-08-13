//
//  ImageStore.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 18/07/2023.
//


import UIKit

class ImageStore {
    let cache = NSCache<NSString,UIImage>()
    
    func setImage(_ image: UIImage, forKey key: String, rincon:Rincon) {
        cache.setObject(image, forKey: key as NSString)
        
        // Create full URL for image
        //        let url = imageURL(forKey: key)
        let rinconUrl = rinconImageURL(rincon: rincon, forKey: key)
//        print("- setImage url: \(rinconUrl)")
        
        // Turn image into JPEG data
        if let data = image.jpegData(compressionQuality: 0.5) {
            // Write it to full URL
            try? data.write(to: rinconUrl)
            
        }
    }
    
    func image(forKey key: String, rincon:Rincon) -> UIImage? {
        
        //        return cache.object(forKey: key as NSString)
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        }
        //        let url = imageURL(forKey: key)
        let rinconUrl = rinconImageURL(rincon: rincon, forKey: key)

        
        guard let imageFromDisk = UIImage(contentsOfFile: rinconUrl.path) else {
            
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        print("-returning image from imageStore - imageRinconUrl: \(rinconUrl)")
        return imageFromDisk
    }
    
    func deleteImage(forKey key: String, rincon:Rincon) {
        cache.removeObject(forKey: key as NSString)
        
//        let url = imageURL(forKey: key)
        let rinconUrl = rinconImageURL(rincon: rincon, forKey: key)
        do {
            try FileManager.default.removeItem(at: rinconUrl)
        } catch {
            print("Error removing the image from disk: \(error)")
        }
    }
    
    // old Photorama example
    func imageURL(forKey key: String) -> URL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent(key)
    }
    
    func rinconImageURL(rincon:Rincon, forKey key: String) -> URL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
//        let rinconFolderName = "rincon_\(rincon_id)"
        let rinconFolderName = rinconImageFolderName(rincon:rincon)
        let rinconFolderPath = documentDirectory.appendingPathComponent(rinconFolderName)
        
        return rinconFolderPath.appendingPathComponent(key)
    }
    
    
    func returnFailedToLoadImage() -> UIImage? {
        print("returning: FailedToLoad -")
        let key = "failedToDownload01d.jpg"
        //        return cache.object(forKey: key as NSString)
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        }
        let url = imageURL(forKey: key)
        print("failed to load url: \(url)")
        //                let rinconUrl = rinconImageURL(rincon_id: rincon_id, forKey: key)
        
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }
    
    
    /* Video specific */

    
}

