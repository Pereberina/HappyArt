//
//  Background.swift
//  HappyArt
//
//  Created by Admin on 04.05.15.
//  Copyright (c) 2015 com.mipt. All rights reserved.
//

import UIKit

protocol BackgroundProtocol {
    func changeBackColor(color: UIColor)
    func drawBezierBuffer(bezierBuffer: [CustomBezier])
    func removeAll()
}

class Background: UIView {
    var bezierBuffer: [CustomBezier] = []
    var isFirstCall: Bool
    
    required init(coder aDecoder: NSCoder) {
        self.isFirstCall = true
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        if self.isFirstCall {
            self.isFirstCall = false
            return
        }
        for bezier in self.bezierBuffer {
            if bezier.isFilling {
                bezier.fillColor.setFill()
                bezier.bezier.fill()
            }
            bezier.color.setStroke()
            bezier.bezier.stroke()
        }
    }
}

extension Background: BackgroundProtocol {
    func changeBackColor(color: UIColor) {
        self.backgroundColor = color
    }
    
    func drawBezierBuffer(bezierBuffer: [CustomBezier]) {
        self.bezierBuffer += bezierBuffer
        self.setNeedsDisplay()
    }
    
    func removeAll() {
        self.bezierBuffer.removeAll()
        self.changeBackColor(UIColor.whiteColor())
        self.setNeedsDisplay()
    }
}

extension Background: ImageOpening {
    func openImage(image: UIImage, name: String) {
        self.backgroundColor = UIColor(patternImage: image)
    }
}

