//
//  LaunchViewController.swift
//  Pigeon
//
//  Created by Wanting Huang on 3/21/15.
//  Copyright (c) 2015 Kyungmin Kim. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var pigeonImageView: UIImageView!
    @IBOutlet weak var postcardImageView: UIImageView!
    @IBOutlet weak var pigeonText: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // now create a bezier path that defines our curve
        // the animation function needs the curve defined as a CGPath
        // but these are more difficult to work with, so instead
        // we'll create a UIBezierPath, and then create a
        // CGPath from the bezier when we need it
        let pathPigeon = UIBezierPath()
        pathPigeon.moveToPoint(CGPoint(x: -10,y: 53))
        pathPigeon.addCurveToPoint(CGPoint(x: 350, y: 70), controlPoint1: CGPoint(x: 180, y: 130), controlPoint2: CGPoint(x: 200, y: 150))
        let pathPostcard = UIBezierPath()
        pathPostcard.moveToPoint(CGPoint(x: -10,y: 78))
        pathPostcard.addCurveToPoint(CGPoint(x: 160, y:430 ), controlPoint1: CGPoint(x: 110, y: 260), controlPoint2: CGPoint(x: 150, y: 100))
        
        // create a new CAKeyframeAnimation that animates the objects position
        let animPigeon = CAKeyframeAnimation(keyPath: "position")
        let animPostcard = CAKeyframeAnimation(keyPath: "position")
        
        // set the animations path to our bezier curve
        animPigeon.path = pathPigeon.CGPath
        animPostcard.path = pathPostcard.CGPath
        
        
        // set some more parameters for the animation
        // this rotation mode means that our object will rotate so that it's parallel to whatever point it is currently on the curve
        animPigeon.rotationMode = kCAAnimationRotateAuto
        //animPigeon.repeatCount = Float.infinity
        animPigeon.duration = 2.0
        animPigeon.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
        //animPostcard.rotationMode = kCAAnimationRotateAuto
        //animPostcard.repeatCount = Float.infinity
        animPostcard.duration = 3.0
        animPostcard.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
        
        // we add the animation to the squares 'layer' property
        pigeonImageView.layer.addAnimation(animPigeon, forKey: "animate position along path")
        postcardImageView.layer.addAnimation(animPostcard, forKey: "animate position along path")
        UIView.animateWithDuration(0.5, delay: 3, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: nil, animations: {
            //self.postcardImageView.frame.origin.y + 10
            
            }, completion: { finished in
                // any code entered here will be applied
                // once the animation has completed
                
        })
        
        UIView.animateWithDuration(0.5, delay: 3.5, options: nil, animations: { () -> Void in
            self.pigeonText.alpha = 0.99
        }) { finished in
            
            UIView.animateWithDuration(1.5, animations: { () -> Void in
                self.pigeonText.alpha = 1
                }) { finished in
                     self.performSegueWithIdentifier("frontContainerSegue", sender: self)
            }
            
        }

        
        // Do any additional setup after loading the view.
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
