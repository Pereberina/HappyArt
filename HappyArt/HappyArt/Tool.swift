//
//  Tool.swift
//  HappyArt
//
//  Created by Admin on 02.05.15.
//  Copyright (c) 2015 com.mipt. All rights reserved.
//

import UIKit

let multipleForBrush = CGFloat(25)
let minSizeForBrush = CGFloat(0.1)
let sizeOfStrongSprayer = CGFloat(0.2)
let sizeOfSoftSprayer = CGFloat(2)

let tools = ["Brush", "Line", "Rect", "Oval", "Rubber", "Strong Sprayer", "Soft Sprayer"]

class Tool {
    var mainTool: String
    var color: UIColor
    var fillColor: UIColor
    var isFilling: Bool
    var transparent: CGFloat
    var size: CGFloat
    var start: CGPoint
    var end: CGPoint
    var isDrawing: Bool
    
    init() {
        color = UIColor.blackColor()
        transparent = 1.0
        start = CGPoint(x: 0, y: 0)
        end = CGPoint(x: 0, y: 0)
        mainTool = tools[0]
        isDrawing = false
        size = defaultLineWidth
        fillColor = UIColor.blackColor()
        isFilling = false
        
    }
    
    func changeLastBezier(pathCustom: CustomBezier) {
        var path = pathCustom.bezier
        
        switch mainTool {
        case "Brush":
            path.addLineToPoint(end)
        case "Line":
            path.removeAllPoints()
            path.moveToPoint(start)
            path.addLineToPoint(end)
        case "Rect":
            path.removeAllPoints()
            path.appendPath(UIBezierPath(rect: CGRect(origin: start, size: CGSize(width: end.x - start.x, height: end.y - start.y))))
        case "Oval":
            path.removeAllPoints()
            path.appendPath(UIBezierPath(ovalInRect: CGRect(origin: start, size: CGSize(width: end.x - start.x, height: end.y - start.y))))
        case "Rubber":
            pathCustom.color = UIColor.whiteColor()
            pathCustom.color = pathCustom.color.colorWithAlphaComponent(1.0)
            pathCustom.isFilling = false
            path.addLineToPoint(end)
        case "Strong Sprayer":
            addStrongSprayer(path)
        case "Soft Sprayer":
            addSoftSprayer(path)
        default:
            path.addLineToPoint(end)
        }
    }
    
    func setPoint(pathCustom: CustomBezier) {
        var path = pathCustom.bezier
        
        if (abs(end.x - start.x) < size) || (abs(end.y - start.y) < size) {
            end = CGPoint(x: start.x, y: start.y+size)
        }
        path.addLineToPoint(end)
    }
    
    func addLine(path: UIBezierPath) -> UIBezierPath {
        path.moveToPoint(start)
        path.addLineToPoint(end)
        
        return path
    }
    
    func addStrongSprayer(path: UIBezierPath) {
        var r = CGFloat(arc4random())
        var phi = CGFloat(arc4random())
        
        r = (r / CGFloat(UINT32_MAX))*size/2
        phi = (phi / CGFloat(UINT32_MAX))*CGFloat(2*M_PI)
        path.moveToPoint(CGPoint(x: end.x+r*cos(phi), y: end.y+r*sin(phi)))
        path.addLineToPoint(CGPoint(x: end.x+r*cos(phi)+sizeOfStrongSprayer, y: end.y+r*sin(phi)+sizeOfStrongSprayer))
    }
    
    func addSoftSprayer(path: UIBezierPath) {
        var r = CGFloat(arc4random())
        var phi = CGFloat(arc4random())
        
        path.lineWidth = sizeOfSoftSprayer
        r = (r / CGFloat(UINT32_MAX))*size*4
        phi = (phi / CGFloat(UINT32_MAX))*CGFloat(2*M_PI)
        path.moveToPoint(CGPoint(x: end.x+r*cos(phi), y: end.y+r*sin(phi)))
        path.addLineToPoint(CGPoint(x: end.x+r*cos(phi)+sizeOfSoftSprayer, y: end.y+r*sin(phi)+sizeOfSoftSprayer))
    }
}








