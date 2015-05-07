//
//  ErrorAllert.swift
//  HappyArt
//
//  Created by Jenny on 07.05.15.
//  Copyright (c) 2015 com.mipt. All rights reserved.
//

import UIKit


func showErrorAllert(sender: UIViewController, message: String) {
    let tapAlert = UIAlertController(title: NSLocalizedString("Error", comment: "Error"), message: NSLocalizedString(message, comment: "Error description"), preferredStyle: UIAlertControllerStyle.Alert)
    
    tapAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Skip"), style: .Destructive, handler: nil))
    sender.presentViewController(tapAlert, animated: true, completion: nil)
}


