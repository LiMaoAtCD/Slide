//
//  ViewController.swift
//  Slide
//
//  Created by limao on 16/5/18.
//  Copyright © 2016年 limao. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIGestureRecognizerDelegate {
    var leftViewController: LeftViewController!
    var centerViewController: CenterViewController!
    
    var leftView: UIView!
    var centerView: UIView!
    
    var panGesture: UIPanGestureRecognizer!
    var rate: CGFloat = 0.8
    var currentDistance: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let imageview = UIImageView.init(image: UIImage.init(named: "backGround")!)
        imageview.frame = view.bounds
        view.addSubview(imageview)
        
        leftViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LeftViewController") as! LeftViewController
        centerViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CenterViewController") as! CenterViewController

        self.addChildViewController(leftViewController)
        self.addChildViewController(centerViewController)
        
        
        //centerView
        view.addSubview(centerViewController.view)
        centerViewController.view.frame = CGRectMake(0, 0, Common.screenWidth, Common.screenHeight)
        centerView = centerViewController.view
        centerView.backgroundColor = UIColor.greenColor()
        
        //leftView
        view.addSubview(leftViewController.view)
        leftViewController.view.backgroundColor = UIColor.redColor()
        leftViewController.view.frame = CGRectMake(-Common.screenWidth, 0, Common.screenWidth, Common.screenHeight)
        leftView = leftViewController.view
        leftView.backgroundColor = UIColor.clearColor()
       
        
        panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(self.pan(_:)))
        self.view.addGestureRecognizer(panGesture)
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    
    var gestrueFinished: Bool = true
    func pan(gesture: UIPanGestureRecognizer) {
        let locationX =  gesture.locationInView(self.view).x

        if gesture.state == .Began {
            if locationX >= 50 && locationX <= Common.screenWidth * rate {
                gestrueFinished = false
                return
            }
        }
        
        
        let offsetX = gesture.translationInView(self.view).x
        let MaxX = Common.screenWidth * rate

        if gestrueFinished {
            if currentDistance + offsetX >= MaxX {
                centerView.frame = CGRectMake(MaxX, 0, Common.screenWidth, Common.screenHeight)
                leftView.frame = CGRectMake(0, 0, Common.screenWidth, Common.screenHeight)
            } else if currentDistance + offsetX <= 0 {
                centerView.frame = CGRectMake(0, 0, Common.screenWidth, Common.screenHeight)
                leftView.frame = CGRectMake(-Common.screenWidth, 0, Common.screenWidth, Common.screenHeight)
            } else {
                centerView.frame = CGRectMake(currentDistance + offsetX, 0,Common.screenWidth, Common.screenHeight)
                leftView.frame = CGRectMake((currentDistance + offsetX) / rate - Common.screenWidth, 0, Common.screenWidth, Common.screenHeight)
            }
        }
        
        if gesture.state == .Ended || gesture.state == .Cancelled {
            
            if gestrueFinished == true {
                let x = currentDistance + offsetX
                let edge = (Common.screenWidth * rate) / 2
                
                var duration: NSTimeInterval = 0.5
                if x >= edge {
                    duration = Double( (MaxX - x) * 2 / MaxX) * duration
                    animateToRight(true, duration: duration)
                } else {
                    duration = Double( x * 2 / MaxX) * duration
                    animateToRight(false, duration: duration)
                }
            }
            gestrueFinished = true
            
        }
    }

    func animateToRight(sure: Bool, duration: NSTimeInterval) {
        if sure {
            UIView.animateWithDuration(duration, animations: {
                self.centerView.frame = CGRectMake(Common.screenWidth * self.rate, 0, Common.screenWidth, Common.screenHeight)
                self.leftView.frame = CGRectMake(0, 0, Common.screenWidth, Common.screenHeight)
            }) { (finished) in
                self.currentDistance = self.centerView.frame.origin.x
            }
        } else {
            UIView.animateWithDuration(duration, animations: {
                self.centerView.frame = CGRectMake(0, 0, Common.screenWidth, Common.screenHeight)
                self.leftView.frame = CGRectMake(-Common.screenWidth, 0, Common.screenWidth, Common.screenHeight)

            }) { (finished) in
                self.currentDistance = self.centerView.frame.origin.x
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

struct Common {
    static let screenWidth = UIScreen.mainScreen().bounds.size.width
    static let screenHeight = UIScreen.mainScreen().bounds.size.height
}

