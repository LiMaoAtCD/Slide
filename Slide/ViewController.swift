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
    var transform: CATransform3D! = CATransform3DIdentity
    
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
        
        transform.m34 = 1 / Common.screenWidth
        self.centerView.layer.anchorPoint.x = 1
        self.centerView.frame = CGRectMake(0, 0, Common.screenWidth, Common.screenHeight)

    }
    
    
    var gestureFinished: Bool = true
    func pan(gesture: UIPanGestureRecognizer) {
        
//        let locationX =  gesture.locationInView(self.view).x
//        if gesture.state == .Began {
//            if locationX >= 50 && locationX <= Common.screenWidth * rate {
//                gestureFinished = false
//                return
//            }
//        }
        
        let offsetX = gesture.translationInView(self.view).x
        let MaxX = Common.screenWidth * rate

//        if gestureFinished {
            if currentDistance + offsetX >= MaxX {
                
                let rotateTransform = CATransform3DRotate(transform, CGFloat( M_PI_4) * 0.5 , 0, 1, 0)
                let translateTransform = CATransform3DTranslate(transform, 100, 0, 0)
                centerView.layer.transform = CATransform3DConcat(rotateTransform, translateTransform)
                leftView.frame = CGRectMake(0, 0, Common.screenWidth, Common.screenHeight)
                
            } else if currentDistance + offsetX <= 0 {
                centerView.layer.transform = transform
                leftView.frame = CGRectMake(-Common.screenWidth, 0, Common.screenWidth, Common.screenHeight)
            } else {
                let x = (currentDistance + offsetX) / MaxX
                let rotateTransform = CATransform3DRotate(transform, CGFloat( M_PI_4) * 0.5 * x , 0, 1, 0)
                let translateTransform = CATransform3DTranslate(transform, 100 * x, 0, 0)
                centerView.layer.transform = CATransform3DConcat(rotateTransform, translateTransform)
                
                leftView.frame = CGRectMake((currentDistance + offsetX) / rate - Common.screenWidth, 0, Common.screenWidth, Common.screenHeight)
            }
//        }
        
        if gesture.state == .Ended || gesture.state == .Cancelled {
            
//            if gestureFinished == true {
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
//            }
//            gestureFinished = true
        }
    }

    func animateToRight(sure: Bool, duration: NSTimeInterval) {
        if sure {
            UIView.animateWithDuration(duration, animations: {
                
                let rotateTransform = CATransform3DRotate(self.transform, CGFloat(M_PI_4) * 0.5 , 0, 1, 0)
                let translateTransform = CATransform3DTranslate(self.transform, 100, 0, 0)
                self.centerView.layer.transform = CATransform3DConcat(rotateTransform, translateTransform)
                self.leftView.frame = CGRectMake(0, 0, Common.screenWidth, Common.screenHeight)
            }) { (finished) in
                self.currentDistance = Common.screenWidth * CGFloat(self.rate)
            }
        } else {
            UIView.animateWithDuration(duration, animations: {
                self.centerView.layer.transform = self.transform
                self.leftView.frame = CGRectMake(-Common.screenWidth, 0, Common.screenWidth, Common.screenHeight)
                
            }) { (finished) in
                self.currentDistance = 0
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

