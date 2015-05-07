//
//  ColorPicker.swift
//  HappyArt
//
//  Created by Jenny on 03.05.15.
//  Copyright (c) 2015 com.mipt. All rights reserved.
//

import UIKit

let numberOfRainbowColors: CGFloat = 8.0
let numberOfColors: CGFloat = 9.0
let numberOfSatLevels: CGFloat = 5.0
let setBackColorSelector: Selector = "setBackColor:"
let setToolColorSelector: Selector = "setToolColor:"
let setBackTransparentLevelSelector: Selector = "setBackTransparentLevel:"
let setToolTransparentLevelSelector: Selector = "setToolTransparentLevel:"
let maxTransparentLevel: CGFloat = 10.0

class ColorView: UIView {
    var delegate: ColorChanging?
    var transparent: UIStepper!
    
    func makeRainbowButtons(buttonFrame:CGRect, sat:CGFloat, bright:CGFloat, action: Selector) {
        var myButtonFrame = buttonFrame
        
        for i in 0..<Int(numberOfRainbowColors) {
            let hue = CGFloat(i) / numberOfRainbowColors
            let color = UIColor(hue: hue, saturation: sat, brightness: bright, alpha: 1.0)
            let aButton = UIButton(frame: myButtonFrame)
            
            myButtonFrame.origin.x = myButtonFrame.size.width + myButtonFrame.origin.x
            aButton.backgroundColor = color
            self.addSubview(aButton)
            aButton.addTarget(self, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        }
        makeNeutralButton(myButtonFrame, sat: sat, action: action)
    }
    
    func makeNeutralButton(buttonFrame:CGRect, sat:CGFloat,  action: Selector) {
        var myButtonFrame = buttonFrame
        let color = UIColor(red: 1 - sat, green: 1 - sat, blue: 1 - sat, alpha: 1.0)
        let aButton = UIButton(frame: myButtonFrame)
        
        aButton.backgroundColor = color
        self.addSubview(aButton)
        aButton.addTarget(self, action: action, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func makeTransparentStepper(buttonFrame: CGRect, action: Selector, value: Double) {
        transparent = UIStepper(frame: buttonFrame)
        transparent.autorepeat = true
        transparent.maximumValue = Double(maxTransparentLevel)
        transparent.value = value*transparent.maximumValue
        self.addSubview(transparent)
        if action == setBackColorSelector {
            transparent.addTarget(self, action: setBackTransparentLevelSelector, forControlEvents: UIControlEvents.ValueChanged)
        } else {
            transparent.addTarget(self, action: setToolTransparentLevelSelector, forControlEvents: UIControlEvents.ValueChanged)
        }
    }
    
    func setBackColor(sender:UIButton) {
        let color = sender.backgroundColor!
        
        delegate?.changeBackColor(color)
        self.transparent.value = Double(maxTransparentLevel)
    }
    
    func setToolColor(sender:UIButton) {
        let color = sender.backgroundColor!
        
        delegate?.changeToolColor(color)
        self.transparent.value = Double(maxTransparentLevel)
    }
    
    func setBackTransparentLevel(sender:UIStepper) {
        let alpha = CGFloat(sender.value) / maxTransparentLevel
        
        delegate?.changeBackTransparentLevel(alpha)
    }
    
    func setToolTransparentLevel(sender:UIStepper) {
        let alpha = CGFloat(sender.value) / maxTransparentLevel
        
        delegate?.changeToolTransparentLevel(alpha)
    }
}