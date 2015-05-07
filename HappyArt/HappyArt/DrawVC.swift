//
//  ViewController.swift
//  HappyArt
//
//  Created by Jenny on 30.04.15.
//  Copyright (c) 2015 com.mipt. All rights reserved.
//

import UIKit

protocol ColorChanging {
    func changeBackColor(color: UIColor)
    func changeToolColor(color: UIColor)
    func changeBackTransparentLevel(alpha: CGFloat)
    func changeToolTransparentLevel(alpha: CGFloat)
}

let blackoutOfDrawView = CGFloat(0.5)
let timeForBlackout = Double(0.4)

class DrawVC: UIViewController {
    @IBOutlet weak var drawRect: DrawRect!
    @IBOutlet weak var sizeOfBrush: UISlider!
    @IBOutlet weak var background: Background!
    @IBOutlet weak var toolsView: UIView!
    @IBOutlet weak var drawView: UIView!
    @IBOutlet weak var colorView: ColorView!
    @IBOutlet weak var hide: UIButton!
    @IBOutlet weak var backColor: UIButton!
    @IBOutlet weak var toolColor: UIButton!
    @IBOutlet weak var viewForPicker: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var tool: UIButton!
    @IBOutlet weak var currColor: UIButton!
    
    var openedImage = OpenedImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sizeOfBrush.value = Float((defaultLineWidth - minSizeForBrush)/multipleForBrush)
        self.colorView.hidden = true
        self.pickerView.hidden = true
        self.viewForPicker.hidden = true
        self.viewForPicker.backgroundColor = colorView.backgroundColor
        self.viewForPicker.layer.cornerRadius = 10.0
        self.viewForPicker.layer.borderColor = UIColor.blackColor().CGColor
        self.viewForPicker.layer.borderWidth = 0.5
        self.colorView.delegate = self.drawRect
        self.drawRect.delegate = self
        self.drawRect.backgroundDelegate = self.background
        self.tool.setTitle(NSLocalizedString(self.drawRect.tool.mainTool, comment: "Tool"), forState: UIControlState.Normal)
        self.currColor.layer.borderWidth = 1
        self.currColor.layer.borderColor = UIColor.blackColor().CGColor
        self.switcher.on = false
        if openedImage.openedImageExists == true {
            openImage(openedImage.image!, name: openedImage.name!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveImage(sender: UIButton) {
        let imageSaveVC = self.storyboard?.instantiateViewControllerWithIdentifier("imageSaveVC") as! ImageSaveVC
        
        imageSaveVC.delegate = self
        if openedImage.openedImageExists == true {
            imageSaveVC.defaultName = openedImage.name
        }
        self.navigationController?.pushViewController(imageSaveVC, animated: true)
    }
    
    
    @IBAction func cancelAction(sender: AnyObject) {
        self.drawRect.removeLast()
    }
    
    @IBAction func changedSizeOfBrush(sender: AnyObject) {
        self.drawRect.tool.size = multipleForBrush * CGFloat(sizeOfBrush.value) + minSizeForBrush
    }
    
    
    @IBAction func setColorViewBackColor(sender: UIButton) {
        self.currColor.backgroundColor = self.background.backgroundColor
        self.showColorView(setBackColorSelector)
    }
    
    @IBAction func hideColorView(sender: UIButton) {
        for view in self.colorView.subviews {
            if (view as? UIButton != currColor) && (view as? UIButton != hide) {
                view.removeFromSuperview()
            }
        }
        self.colorView.hidden = true
    }
    
    
    @IBAction func setColorViewToolColor(sender: UIButton) {
        self.currColor.backgroundColor = self.drawRect.tool.color.colorWithAlphaComponent(self.drawRect.tool.transparent)
        self.showColorView(setToolColorSelector)
    }
    
    @IBAction func cancelAll(sender: UIButton) {
        self.drawRect.removeAll()
        if openedImage.openedImageExists == true {
            self.drawRect.changeBackColor(UIColor(patternImage: openedImage.image!))
        } else {
            self.drawRect.changeBackColor(UIColor.whiteColor())
        }
        self.drawRect.changeToolColor(UIColor.blackColor())
    }
    
    @IBAction func changeTool(sender: UIButton) {
        self.pickerView.hidden = false
        self.viewForPicker.hidden = false
        self.drawRect.userInteractionEnabled = false
        UIView.animateWithDuration(timeForBlackout,
            animations: { ()->Void in
                self.drawRect.layer.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(blackoutOfDrawView).CGColor
            },
            completion: nil)
    }
    
    
    @IBAction func switcherChanged(sender: AnyObject) {
        self.drawRect.tool.isFilling = switcher.on
    }
    
    @IBAction func handlePinch(recognizer : UIPinchGestureRecognizer) {
        let scale = CGFloat(2)
        var xDir = drawRect.bounds.size.width/2 - recognizer.locationInView(drawRect).x
        var yDir = drawRect.bounds.size.height/2 - recognizer.locationInView(drawRect).y
        var tx = (recognizer.scale - 1) * xDir * scale
        var ty = (recognizer.scale - 1) * yDir * scale
        
        drawRect.transform = CGAffineTransformScale(drawRect.transform, recognizer.scale, recognizer.scale)
        drawRect.transform = CGAffineTransformTranslate(drawRect.transform, tx, ty)
        background.transform = CGAffineTransformScale(background.transform, recognizer.scale, recognizer.scale)
        background.transform = CGAffineTransformTranslate(background.transform, tx, ty)
        recognizer.scale = 1
    }
    
    func showColorView(action: Selector) {
        var buttonFrame = CGRect(x: 0, y: 0, width: self.setColorButtonWidth(action), height: self.setColorButtonHeight(action))
        var i = CGFloat(1.0)
        var k = CGFloat(i/numberOfSatLevels)
        
        self.colorView.hidden = false
        while i >= 0 {
            self.colorView.makeRainbowButtons(buttonFrame, sat: i, bright: 1.0, action: action)
            i -= k
            buttonFrame.origin.y = buttonFrame.origin.y + buttonFrame.size.height
        }
        var locStepper = CGPoint(x: self.hide.frame.origin.x - 35, y: self.hide.frame.origin.y - 55)
        buttonFrame = CGRect(origin: locStepper, size: CGSize(width: 0, height: 0))
        if action == setBackColorSelector {
            var alpha: CGFloat = 0.0
            self.backColor.backgroundColor?.getWhite(nil, alpha: &alpha)
            self.colorView.makeTransparentStepper(buttonFrame, action: action, value: Double(alpha))
        } else {
            self.colorView.makeTransparentStepper(buttonFrame, action: action, value: Double(self.drawRect.tool.transparent))
        }
    }
    
    
    func setColorButtonWidth(action: Selector) -> CGFloat {
        return (self.colorView.frame.width - (self.hide.frame.width + 50))/numberOfColors
    }
    
    func setColorButtonHeight(action: Selector) -> CGFloat {
        return self.colorView.frame.height/(numberOfSatLevels + 1)
    }
    
}

extension DrawVC: ImageSaving {
    func takeImage() -> UIImage {
        self.drawRect.flushToBackground()
        UIGraphicsBeginImageContext(self.background.bounds.size)
        self.background.layer.renderInContext(UIGraphicsGetCurrentContext())
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.openedImage.image = image
        
        return image
    }

    func imageSaved(name: String) {
        self.navigationItem.title = name
        openedImage.openedImageExists = true
        openedImage.name = name
    }
}

extension DrawVC: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tools.count
    }
}

extension DrawVC: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return NSLocalizedString(tools[row], comment: "Tool")
    }
    
    func  pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.drawRect.tool.mainTool = tools[row]
        self.tool.setTitle(NSLocalizedString(tools[row], comment: "Tool"), forState: UIControlState.Normal)
        self.pickerView.hidden = true
        self.viewForPicker.hidden = true
        UIView.animateWithDuration(timeForBlackout,
            animations: { () -> Void in
                self.drawRect.layer.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.0).CGColor
            },
            completion: nil)
        self.drawRect.userInteractionEnabled = true
    }
}

extension DrawVC: ColorChanging {
    func changeBackColor(color: UIColor) {
        self.backColor.backgroundColor = color
        self.currColor.backgroundColor = color
    }
    
    func changeToolColor(color: UIColor) {
        self.toolColor.backgroundColor = color
        self.currColor.backgroundColor = color
    }

    func changeBackTransparentLevel(alpha: CGFloat) {
        let color = self.currColor.backgroundColor?.colorWithAlphaComponent(alpha)
        
        self.background.backgroundColor = color
        self.currColor.backgroundColor = color
        self.backColor.backgroundColor = color
    }
    
    func changeToolTransparentLevel(alpha: CGFloat) {
        let color = self.currColor.backgroundColor?.colorWithAlphaComponent(alpha)
        
        self.currColor.backgroundColor = color
        self.toolColor.backgroundColor = color
    }
}

extension DrawVC: ImageOpening {
    func openImage(image: UIImage, name: String) {
        self.background.openImage(image, name: name)
        self.navigationItem.title = name
    }
}

