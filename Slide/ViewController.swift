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
    
    
    
    
    
    var panGesture: UIPanGestureRecognizer!
    var rate: CGFloat = 0.8
    var currentDistance: CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        leftViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LeftViewController") as! LeftViewController
        centerViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CenterViewController") as! CenterViewController

        self.addChildViewController(leftViewController)
        self.addChildViewController(centerViewController)
        
        view.addSubview(leftViewController.view)
        leftViewController.view.backgroundColor = UIColor.redColor()
        view.addSubview(centerViewController.view)
        leftViewController.view.frame = self.view.bounds
        
        centerViewController.view.frame = CGRectMake(0, 0, Common.screenWidth, Common.screenHeight)

        panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(self.pan(_:)))

        self.view.addGestureRecognizer(panGesture)
    }
    
    func pan(gesture: UIPanGestureRecognizer) {
        let offsetX = gesture.translationInView(self.view).x
        if currentDistance + offsetX >= Common.screenWidth * rate {
            centerViewController.view.frame = CGRectMake(Common.screenWidth * rate, 0, Common.screenWidth, Common.screenHeight)
        } else if currentDistance + offsetX <= 0 {
            centerViewController.view.frame = CGRectMake(0, 0, Common.screenWidth, Common.screenHeight)
        } else {
            centerViewController.view.frame = CGRectMake(currentDistance + offsetX, 0,Common.screenWidth, Common.screenHeight)
        }

        if gesture.state == .Ended {
            
            animateToRight(centerViewController.view.frame.origin.x >= (Common.screenWidth * rate) / 2 ? true : false)

        }
        
    }

    func animateToRight(sure: Bool) {
        
        if sure {
            UIView.animateWithDuration(0.2, animations: {
                self.centerViewController.view.frame = CGRectMake(Common.screenWidth * self.rate, 0, Common.screenWidth, Common.screenHeight)
            }) { (finished) in
                self.currentDistance = self.centerViewController.view.frame.origin.x
            }
        } else {
            UIView.animateWithDuration(0.2, animations: {
                self.centerViewController.view.frame = CGRectMake(0, 0, Common.screenWidth, Common.screenHeight)
            }) { (finished) in
                self.currentDistance = self.centerViewController.view.frame.origin.x
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
    static let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController as! ViewController
}

