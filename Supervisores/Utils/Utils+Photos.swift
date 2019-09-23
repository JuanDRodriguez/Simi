//
//  Utils+Photos.swift
//  Supervisores
//
//  Created by Sharepoint on 5/8/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit
import Photos

extension Utils {
    
    static func savePhoto(photo: UIImage) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: photo)
        }, completionHandler: { success, error in
            if success {
                print("FOTO GUARDADA!!!")
            }
            else if let error = error {
                print("FOTO GUARDADA ERROR \(error)")
            }
            else {
                print("FOTO GUARDADA ALGO RARO")
            }
        })
    }
    
}
