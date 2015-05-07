//
//  InputVC.swift
//  HappyArt
//
//  Created by Jenny on 30.04.15.
//  Copyright (c) 2015 com.mipt. All rights reserved.
//

import UIKit


class InputVC: UIViewController {
    @IBOutlet weak var open: UIButton!
    @IBOutlet weak var new: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func newPicture(sender: UIButton) {
        let mainVC = self.storyboard?.instantiateViewControllerWithIdentifier("mainVC") as! DrawVC
        
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
    
    @IBAction func openPicture(sender: UIButton) {
        
        let imageOpenVC = self.storyboard?.instantiateViewControllerWithIdentifier("imageOpenVC") as! ImageOpenVC
        self.navigationController?.pushViewController(imageOpenVC, animated: true)
    }
  
}