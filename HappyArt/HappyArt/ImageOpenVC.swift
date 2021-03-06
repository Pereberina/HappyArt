//
//  ImageOpenVC.swift
//  HappyArt
//
//  Created by Jenny on 30.04.15.
//  Copyright (c) 2015 com.mipt. All rights reserved.
//

import UIKit

protocol ModeledView: NSObjectProtocol {
    var viewModel: AnyObject? { get set }
}
class ImageCell: UICollectionViewCell, UIGestureRecognizerDelegate, ModeledView {
    @IBOutlet weak var imageView: UIImageView!
    
   
    var viewModel: AnyObject? {
        didSet {
            if let data = viewModel as? ImageCellViewModel {
                self.imageView.image = data.image
                data.longPressRec.addTarget(self, action: "deleteImage")
                self.imageView.addGestureRecognizer(data.longPressRec)
                self.imageView.userInteractionEnabled = true
                self.backgroundColor = UIColor.blackColor()
            }
        }
    }
    
    func deleteImage() {
        if let data = viewModel as? ImageCellViewModel {
            data.deleteImage()
        }
    }
}

class ImageCellViewModel {
    var image: UIImage
    var imagePath: String
    var delegate: ImageDeleting?
    var longPressRec = UILongPressGestureRecognizer()
    
    init(image: UIImage, imagePath: String, delegate: ImageDeleting) {
        self.image = image
        self.imagePath = imagePath
        self.delegate = delegate
    }
    
    func deleteImage() {
        self.delegate?.deleteImage(self.imagePath)
    }
}


protocol ImageOpening {
    func openImage(image: UIImage, name: String)
}

protocol ImageDeleting {
    func deleteImage(path: String)
}

struct OpenedImage {
    var openedImageExists = false
    var image: UIImage?
    var name: String?
}

class ImageOpenVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var isEmpty: UILabel!
    
    var imageSet = ImageSet()
    
    override func viewDidLoad() {
        super.viewDidAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        updateImageCollection()
    }
    
    func updateImageCollection() -> Void {
        self.imageSet.setImages()
        if self.imageSet.images.image.count == 0 {
            self.collectionView.hidden = true
            self.isEmpty.hidden = false
        }
        self.collectionView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.imageSet.clear()
    }
}

extension ImageOpenVC: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageSet.images.image.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! ImageCell

        let longPressRec = UILongPressGestureRecognizer()
        var data = ImageCellViewModel(image: self.imageSet.images.image[indexPath.row],
                                        imagePath: self.imageSet.images.path[indexPath.row],
                                            delegate: self)
        
        cell.viewModel = data
        
        return cell
    }
}

extension ImageOpenVC: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let mainVC = self.storyboard?.instantiateViewControllerWithIdentifier("mainVC") as! DrawVC
        
        mainVC.openedImage.openedImageExists = true
        mainVC.openedImage.image = self.imageSet.images.image[indexPath.row]
        mainVC.openedImage.name = self.imageSet.images.path[indexPath.row].lastPathComponent
        self.navigationController?.pushViewController(mainVC, animated: true)
    }

}

extension ImageOpenVC: ImageDeleting {
    func deleteImage(path: String) {
        let tapAlert = UIAlertController(title: NSLocalizedString("Delete", comment: "Title").stringByAppendingString(" \(path.lastPathComponent)?"), message: NSLocalizedString("You won't be able to cancel this action!", comment: "Message"), preferredStyle: UIAlertControllerStyle.Alert)
        
        tapAlert.addAction(UIAlertAction(title: NSLocalizedString("YES", comment: "Agree"), style: .Destructive,
            handler: { action in
                let fileManager = NSFileManager.defaultManager()
                
                fileManager.removeItemAtPath(path, error: nil)
                self.imageSet.clear()
                self.updateImageCollection()
        }))
        tapAlert.addAction(UIAlertAction(title: NSLocalizedString("NO", comment: "Cancel"), style: .Cancel, handler: nil))
        self.presentViewController(tapAlert, animated: true, completion: nil)
    }
}