//
//  BezierBuffer.swift
//  HappyArt
//
//  Created by Admin on 03.05.15.
//  Copyright (c) 2015 com.mipt. All rights reserved.
//

import UIKit

let defaultLineWidth = CGFloat(3)

class CustomBezier {
    var bezier: UIBezierPath
    var color: UIColor
    var isFilling: Bool
    var fillColor: UIColor
    
    init() {
        color = UIColor.blackColor()
        bezier = UIBezierPath()
        bezier.lineWidth = defaultLineWidth
        isFilling = false
        fillColor = UIColor.blackColor()
    }
}