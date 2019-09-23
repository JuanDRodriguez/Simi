//
//  SupervisionResume+Delegate.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 3/18/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import Foundation
import UIKit

extension SupervisionResumeViewController: UITableViewDelegate {
    func setPhotosToAnswers(photos: [String : Any], answers:[[String : Any]] ) -> [[String : Any]]? {
        var valueReturn : [[String : Any]]?
        print("DictionaryPhotos: \(photos)")
        print("DictionaryAnswers: \(answers)")
        
        
        return valueReturn
    }
}
