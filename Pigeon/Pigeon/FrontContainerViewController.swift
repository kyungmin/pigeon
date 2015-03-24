//
//  FrontContainerViewController.swift
//  Pigeon
//
//  Created by Wanting Huang on 3/20/15.
//  Copyright (c) 2015 Kyungmin Kim. All rights reserved.
//

import UIKit

class FrontContainerViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var frontView: UIView!
    var frontViewController: FrontViewController!
    var menuViewController: MenuViewController!
    var frontViewStartingPositionX: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        frontViewController = storyboard.instantiateViewControllerWithIdentifier("frontStoryboardId") as FrontViewController
        menuViewController = storyboard.instantiateViewControllerWithIdentifier("menuStoryboardId") as MenuViewController
        
        addChildViewController(frontViewController)
        frontViewController.didMoveToParentViewController(self)
        addChildViewController(menuViewController)
        menuViewController.didMoveToParentViewController(self)
        
        frontView.addSubview(frontViewController.view)
        menuView.addSubview(menuViewController.view)
        
        //Add menuButton
        let menuButton   = UIButton.buttonWithType(UIButtonType.System) as UIButton
        menuButton.frame = CGRectMake(8, 20, 46, 30)
            //menuButton.backgroundColor = UIColor.greenColor()
        menuButton.setTitle("", forState: UIControlState.Normal)
        menuButton.addTarget(self, action: "menuButtonDidPress:", forControlEvents: UIControlEvents.TouchUpInside)
        frontView.addSubview(menuButton)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func screenEdgeDidPan(sender: UIScreenEdgePanGestureRecognizer) {
        
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        
        if (sender.state == UIGestureRecognizerState.Began){
            println("pan")
            
            frontViewStartingPositionX = frontView.frame.origin.x
            
            
            
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            
            frontView.frame.origin.x = frontViewStartingPositionX + translation.x
            
            
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            
            if ( velocity.x > 0) {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    
                    self.frontView.frame.origin.x = 270
                    
                    }, completion: { (finished:Bool) -> Void in
                        
                        var panGesture = UIPanGestureRecognizer(target: self, action: "frontViewDidPan:")
                        self.frontView.addGestureRecognizer(panGesture)
                        
                        
                })
                
                
                
            } else {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.frontView.frame.origin.x = 0
                })
            }
            
        }
        
    }
    
    
    @IBAction func menuButtonDidPress(sender: AnyObject) {
        if (frontView.frame.origin.x == 0){
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                
                self.frontView.frame.origin.x = 270
                
                }, completion: { (finished:Bool) -> Void in
                    
                    var panGesture = UIPanGestureRecognizer(target: self, action: "frontViewDidPan:")
                    self.frontView.addGestureRecognizer(panGesture)
                    
                    
            })
        } else {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.frontView.frame.origin.x = 0
            })
            
        }
        
    }
    
    @IBAction func frontViewDidPan(sender: UIPanGestureRecognizer) {
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        
        if (sender.state == UIGestureRecognizerState.Began){
            
            frontViewStartingPositionX = frontView.frame.origin.x
            
            
            
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            
            frontView.frame.origin.x = frontViewStartingPositionX + translation.x
            
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            
            if ( velocity.x > 0) {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    
                    self.frontView.frame.origin.x = 270
                    
                    }, completion: { (finished:Bool) -> Void in
                        
                        
                })
                
            } else {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.frontView.frame.origin.x = 0
                })
            }
            
        }
        
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
