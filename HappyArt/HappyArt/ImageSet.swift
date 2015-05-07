//
//  ImageSet.swift
//  HappyArt
//
//  Created by Jenny on 05.05.15.
//  Copyright (c) 2015 com.mipt. All rights reserved.
//

import UIKit

struct Images {
    var image = [UIImage]()
    var path = [String]()
}

class ImageSet : NSObject {
    var images = Images()
    
    func contentsOfDirectoryAtPath(path: String) -> [String]? {
        let fileManager = NSFileManager.defaultManager()
        let contents = fileManager.contentsOfDirectoryAtPath(path, error: nil)
        
        return contents as! [String]?
    }

    func setImages() -> Void {
        let directory = documentsDirectory()
        
        if let imageNames = contentsOfDirectoryAtPath(directory) {
            for i in 0..<imageNames.count {
                let path = directory.stringByAppendingPathComponent(imageNames[i])
                if let image = openImage(path) {
                    self.images.image.append(image)
                    self.images.path.append(path)
                }
            }
        }
    }

    func openImage(path: String) -> UIImage? {
        println(UIImage(contentsOfFile: path))
        println(path)
        return UIImage(contentsOfFile: path)
    }
    
    func clear() -> Void {
        self.images.image.removeAll(keepCapacity: true)
        self.images.path.removeAll(keepCapacity: true)
    }
}