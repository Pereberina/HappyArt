//
//  drawRect.swift
//  HappyArt
//
//  Created by Admin on 02.05.15.
//  Copyright (c) 2015 com.mipt. All rights reserved.
//
//
//
import UIKit

let maxBeziersForCancel = 10
let maxBeziersInLayer = 20

class DrawRect: UIView, ColorChanging {
    var nBezier: Int
    var bezierBuffer: [CustomBezier] = []
    var tool: Tool
    var isFirstCall: Bool
    
    var delegate: ColorChanging?
    var backgroundDelegate: BackgroundProtocol!
    
    required init(coder aDecoder: NSCoder) {
        tool = Tool()
        isFirstCall = true
        nBezier = 0
        super.init(coder: aDecoder)
        self.setupGestures()
        self.backgroundColor = self.backgroundColor?.colorWithAlphaComponent(0.0)
    }
    
    override func drawRect(rect: CGRect) {
        if self.isFirstCall {
            self.isFirstCall = false
            return
        }
        for bezier in bezierBuffer {
            if bezier.isFilling {
                bezier.fillColor.setFill()
                bezier.bezier.fill()
            }
            bezier.color.setStroke()
            bezier.bezier.stroke()
        }
    }
    
    func removeLast() {
        if self.bezierBuffer.count > 0 {
            self.bezierBuffer.removeLast()
            self.nBezier--;
            self.setNeedsDisplay()
        }
    }
    
    func removeAll() {
        self.bezierBuffer.removeAll()
        self.backgroundDelegate?.removeAll()
        self.nBezier = 0
        self.changeToolColor(UIColor.blackColor())
        self.setNeedsDisplay()
    }
    
    func setupGestures() {
        var pan = UIPanGestureRecognizer(target: self, action: Selector("pan:"))
        
        self.addGestureRecognizer(pan)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.tool.start = (touches.first as! UITouch).locationInView(self)
        self.bezierBuffer.append(CustomBezier())
        self.bezierBuffer.last?.bezier.lineWidth = tool.size
        self.bezierBuffer.last?.color = tool.color
        self.bezierBuffer.last!.color = bezierBuffer.last!.color.colorWithAlphaComponent(tool.transparent)
        self.tool.fillColor = bezierBuffer.last!.color
        self.bezierBuffer.last?.bezier.moveToPoint(tool.start)
        self.bezierBuffer.last?.isFilling = tool.isFilling
        self.bezierBuffer.last?.fillColor = tool.fillColor
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.tool.end = (touches.first as! UITouch).locationInView(self)
        self.tool.setPoint(bezierBuffer.last!)
        self.tool.isDrawing = false
        self.setNeedsDisplay()
        self.nBezier++
        if nBezier == maxBeziersInLayer {
            self.turnCurrentLayerIntoBackground()
            self.nBezier -= maxBeziersInLayer - maxBeziersForCancel
        }
    }
    
    func pan(panGesture: UIPanGestureRecognizer) {
        var pointInView = panGesture.locationInView(self)
        
        if panGesture.state == UIGestureRecognizerState.Changed {
            drawing(pointInView)
        } else {
            if panGesture.state == UIGestureRecognizerState.Ended {
                tool.isDrawing = false
                self.nBezier++
                if self.nBezier == maxBeziersInLayer {
                    self.turnCurrentLayerIntoBackground()
                    self.nBezier -= maxBeziersInLayer - maxBeziersForCancel
                }
            }
        }
    }
    
    func drawing(pointInView: CGPoint) {
        tool.end = pointInView
        tool.changeLastBezier(bezierBuffer.last!)
        tool.isDrawing = true
        self.setNeedsDisplay()
    }
    
    func changeBackColor(color: UIColor) {
        self.backgroundDelegate?.changeBackColor(color)
        self.delegate?.changeBackColor(color)
    }
    
    func changeToolColor(color: UIColor) {
        self.tool.color = color
        self.delegate?.changeToolColor(color)
    }
    
    func changeBackTransparentLevel(alpha: CGFloat) {
        self.delegate?.changeBackTransparentLevel(alpha)
    }
    
    func changeToolTransparentLevel(alpha: CGFloat) {
        self.tool.transparent = alpha
        self.delegate?.changeToolTransparentLevel(alpha)
    }
    
    func turnCurrentLayerIntoBackground() {
        self.backgroundDelegate?.drawBezierBuffer(Array(bezierBuffer[0...maxBeziersInLayer-maxBeziersForCancel-1]))
        self.bezierBuffer.removeRange(0...maxBeziersInLayer-maxBeziersForCancel-1)
    }
    
    func flushToBackground() {
        self.nBezier = 0
        self.backgroundDelegate?.drawBezierBuffer(bezierBuffer)
        self.bezierBuffer.removeAll()
        self.changeToolColor(UIColor.blackColor())
        self.setNeedsDisplay()
    }
    
}










