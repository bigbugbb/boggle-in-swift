//
//  WordBoard.swift
//  boggle
//
//  Created by Bin Bo on 7/21/15.
//  Copyright (c) 2015 Bin Bo. All rights reserved.
//

import UIKit

class WordBoard: UIView {
    
    lazy var game = GameManager.instance.activeGame!
    
    override func drawRect(rect: CGRect) {
        // draw dividers
        drawDividers(rect)
        // draw characters in each sub-block
        drawCharacters(rect)
        // draw selections
        drawSelections(rect)
        // draw selection trace
        drawSelectionTrace(rect)
    }
    
    internal func drawDividers(rect: CGRect) {
        let size = rect.width / CGFloat(game.dimen)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, UIColor.grayColor().CGColor)
        CGContextSetLineWidth(context, 0.5);
        for i in 1..<game.dimen {
            // horizontal lines
            CGContextMoveToPoint(context, 0.0, size * CGFloat(i));
            CGContextAddLineToPoint(context, rect.width, size * CGFloat(i));
            // vertical lines
            CGContextMoveToPoint(context, size * CGFloat(i), 0.0);
            CGContextAddLineToPoint(context, size * CGFloat(i), rect.height);
        }
        CGContextStrokePath(context)
    }
    
    internal func drawCharacters(rect: CGRect) {
        var board = game.board
        let s = NSString(bytes: board, length: board.count, encoding: NSASCIIStringEncoding)! as String
        // set the text color to dark gray
        let fieldColor = UIColor.darkGrayColor()
        // set the font to Helvetica Neue 18
        let fieldFont = UIFont(name: "Helvetica Neue", size: 60)
        // set the alignment to center
        let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = NSTextAlignment.Center
        // set the Obliqueness to 0.1
        var skew = 0.1
        
        var attributes = [
            NSForegroundColorAttributeName: fieldColor,
            NSObliquenessAttributeName: skew,
            NSFontAttributeName: fieldFont!,
            NSParagraphStyleAttributeName: textStyle
        ]
        
        let dimen = game.dimen
        let size = rect.width / CGFloat(game.dimen)
        for var i = 0; i < count(s); i++ {
            let x = CGFloat(i % dimen) * size
            let y = CGFloat(i / dimen) * size
            s[i].drawInRect(CGRectMake(x, y, size, size), withAttributes: attributes)
        }
    }
    
    internal func drawSelections(rect: CGRect) {
        // get the graphics context
        var context = UIGraphicsGetCurrentContext();
        
        let dimen = game.dimen
        let size = self.frame.width / CGFloat(dimen)
        let selections = game.selections
        for (index, value) in enumerate(selections) {
            if index == 0 {
                CGContextSetLineWidth(context, 5.0) // set the circle outerline-width
                UIColor.redColor().set() // set the circle outerline-color
            } else if index + 1 == selections.count {
                CGContextSetLineWidth(context, 3.0)
                UIColor.greenColor().set()
            } else {
                CGContextSetLineWidth(context, 3.0)
                UIColor.blueColor().set()
            }
            
            let x = CGFloat(value % dimen) * size + size / 2
            let y = CGFloat(value / dimen) * size + size / 2
            
            // create circle
            CGContextAddArc(context, x, y, size / 4, 0.0, CGFloat(M_PI * 2.0), 1)
            
            CGContextStrokePath(context);
        }
    }
    
    internal func drawSelectionTrace(rect: CGRect) {
        var context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, UIColor.grayColor().CGColor)
        CGContextSetLineWidth(context, 2);
        
        let dimen = game.dimen
        let size = self.frame.width / CGFloat(game.dimen)
        let offset = size / 5
        let dx = offset / 4
        let dy = offset / 2
        let selections = game.selections
        for var i = 0; i < selections.count - 1; ++i {
            let cx = selections[i] % dimen
            let cy = selections[i] / dimen
            let nx = selections[i + 1] % dimen
            let ny = selections[i + 1] / dimen
            
            switch (nx, ny) {
            case (cx - 1, cy - 1):
                CGContextMoveToPoint(context, CGFloat(cx) * size + offset, CGFloat(cy) * size + offset)
                CGContextAddLineToPoint(context, CGFloat(cx) * size - offset, CGFloat(cy) * size - offset)
                CGContextMoveToPoint(context, CGFloat(cx) * size - offset, CGFloat(cy) * size - offset)
                CGContextAddLineToPoint(context, CGFloat(cx) * size - offset + 0.707 * dx, CGFloat(cy) * size - offset + 2.12 * dx)
                CGContextMoveToPoint(context, CGFloat(cx) * size - offset, CGFloat(cy) * size - offset)
                CGContextAddLineToPoint(context, CGFloat(cx) * size - offset + 2.12 * dx, CGFloat(cy) * size - offset + 0.707 * dx)
            case (cx, cy - 1):
                CGContextMoveToPoint(context, CGFloat(cx) * size + size / 2, CGFloat(cy) * size + offset)
                CGContextAddLineToPoint(context, CGFloat(cx) * size + size / 2, CGFloat(cy) * size - offset)
                CGContextMoveToPoint(context, CGFloat(cx) * size + size / 2, CGFloat(cy) * size - offset)
                CGContextAddLineToPoint(context, CGFloat(cx) * size + size / 2 - dx, CGFloat(cy) * size - offset + dy)
                CGContextMoveToPoint(context, CGFloat(cx) * size + size / 2, CGFloat(cy) * size - offset)
                CGContextAddLineToPoint(context, CGFloat(cx) * size + size / 2 + dx, CGFloat(cy) * size - offset + dy)
            case (cx + 1, cy - 1):
                CGContextMoveToPoint(context, CGFloat(nx) * size - offset, CGFloat(cy) * size + offset)
                CGContextAddLineToPoint(context, CGFloat(nx) * size + offset, CGFloat(cy) * size - offset)
                CGContextMoveToPoint(context, CGFloat(nx) * size + offset, CGFloat(cy) * size - offset)
                CGContextAddLineToPoint(context, CGFloat(nx) * size + offset - 2.12 * dx, CGFloat(cy) * size - offset + 0.707 * dx)
                CGContextMoveToPoint(context, CGFloat(nx) * size + offset, CGFloat(cy) * size - offset)
                CGContextAddLineToPoint(context, CGFloat(nx) * size + offset - 0.707 * dx, CGFloat(cy) * size - offset + 2.12 * dx)
            case (cx - 1, cy):
                CGContextMoveToPoint(context, CGFloat(cx) * size + offset, CGFloat(cy) * size + size / 2)
                CGContextAddLineToPoint(context, CGFloat(cx) * size - offset, CGFloat(cy) * size + size / 2)
                CGContextMoveToPoint(context, CGFloat(cx) * size - offset, CGFloat(cy) * size + size / 2)
                CGContextAddLineToPoint(context, CGFloat(cx) * size - offset + dy, CGFloat(cy) * size + size / 2 - dx)
                CGContextMoveToPoint(context, CGFloat(cx) * size - offset , CGFloat(cy) * size + size / 2)
                CGContextAddLineToPoint(context, CGFloat(cx) * size - offset + dy, CGFloat(cy) * size + size / 2 + dx)
            case (cx + 1, cy):
                CGContextMoveToPoint(context, CGFloat(nx) * size - offset, CGFloat(ny) * size + size / 2)
                CGContextAddLineToPoint(context, CGFloat(nx) * size + offset, CGFloat(ny) * size + size / 2)
                CGContextMoveToPoint(context, CGFloat(nx) * size + offset, CGFloat(ny) * size + size / 2)
                CGContextAddLineToPoint(context, CGFloat(nx) * size + offset - dy, CGFloat(ny) * size + size / 2 - dx)
                CGContextMoveToPoint(context, CGFloat(nx) * size + offset, CGFloat(ny) * size + size / 2)
                CGContextAddLineToPoint(context, CGFloat(nx) * size + offset - dy, CGFloat(ny) * size + size / 2 + dx)
            case (cx - 1, cy + 1):
                CGContextMoveToPoint(context, CGFloat(cx) * size + offset, CGFloat(ny) * size - offset)
                CGContextAddLineToPoint(context, CGFloat(cx) * size - offset, CGFloat(ny) * size + offset)
                CGContextMoveToPoint(context, CGFloat(cx) * size - offset, CGFloat(ny) * size + offset)
                CGContextAddLineToPoint(context, CGFloat(cx) * size - offset + 0.707 * dx, CGFloat(ny) * size + offset - 2.12 * dx)
                CGContextMoveToPoint(context, CGFloat(cx) * size - offset, CGFloat(ny) * size + offset)
                CGContextAddLineToPoint(context, CGFloat(cx) * size - offset + 2.12 * dx, CGFloat(ny) * size + offset - 0.707 * dx)
            case (cx, cy + 1):
                CGContextMoveToPoint(context, CGFloat(cx) * size + size / 2, CGFloat(ny) * size - offset)
                CGContextAddLineToPoint(context, CGFloat(cx) * size + size / 2, CGFloat(ny) * size + offset)
                CGContextMoveToPoint(context, CGFloat(cx) * size + size / 2, CGFloat(ny) * size + offset)
                CGContextAddLineToPoint(context, CGFloat(cx) * size + size / 2 - dx, CGFloat(ny) * size + offset - dy)
                CGContextMoveToPoint(context, CGFloat(cx) * size + size / 2, CGFloat(ny) * size + offset)
                CGContextAddLineToPoint(context, CGFloat(cx) * size + size / 2 + dx, CGFloat(ny) * size + offset - dy)
            case (cx + 1, cy + 1):
                CGContextMoveToPoint(context, CGFloat(nx) * size - offset, CGFloat(ny) * size - offset)
                CGContextAddLineToPoint(context, CGFloat(nx) * size + offset, CGFloat(ny) * size + offset)
                CGContextMoveToPoint(context, CGFloat(nx) * size + offset, CGFloat(ny) * size + offset)
                CGContextAddLineToPoint(context, CGFloat(nx) * size + offset - 2.12 * dx, CGFloat(ny) * size + offset - 0.707 * dx)
                CGContextMoveToPoint(context, CGFloat(nx) * size + offset, CGFloat(ny) * size + offset)
                CGContextAddLineToPoint(context, CGFloat(nx) * size + offset - 0.707 * dx, CGFloat(ny) * size + offset - 2.12 * dx)
            default:
                print("\(nx)\(ny)")
            }
        }
        
        CGContextStrokePath(context);
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            let i = location2Index(touch.locationInView(self))
            game.select(i)
            self.setNeedsDisplay()
        }
        super.touchesBegan(touches, withEvent:event)
    }
    
    internal func location2Index(location: CGPoint) -> Int {
        let size = self.frame.width / CGFloat(game.dimen)
        let x: Int = Int(location.x / size)
        let y: Int = Int(location.y / size)
        return game.dimen * y + x
    }
}
