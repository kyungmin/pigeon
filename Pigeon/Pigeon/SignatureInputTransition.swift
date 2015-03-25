//
//  SignatureInputTransition.swift
//  Pigeon
//
//  Created by Nissana Akranavaseri on 3/20/15.
//  Copyright (c) 2015 Kyungmin Kim. All rights reserved.
//

import UIKit

class SignatureInputTransition: BaseTransition {
    
    override func presentTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        var inputSignature = toViewController as SignatureViewController
        
        toViewController.view.alpha = 0
        inputSignature.containerView.frame.origin = CGPoint(x:-200, y: 355)
        inputSignature.containerView.transform = CGAffineTransformMakeScale(0.5, 0.5)

        toViewController.view.alpha = 0
        UIView.animateWithDuration(duration, animations: {
            toViewController.view.alpha = 1
            inputSignature.containerView.transform = CGAffineTransformMakeScale(1, 1)
            inputSignature.containerView.frame.origin = CGPoint(x:0, y: 0)

            }) { (finished: Bool) -> Void in
                self.finish()
        }
    }
    
    override func dismissTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        var inputSignature = fromViewController as SignatureViewController
        inputSignature.doneButton.hidden = true
        //var mainBackController = toViewController as BackViewController -- ERROR
        
        var movingView = inputSignature.containerView
        movingView.frame = inputSignature.containerView.frame
        containerView.addSubview(movingView)
        
        var movingSignature = inputSignature.signatureView
        containerView.addSubview(movingSignature)
        
        fromViewController.view.alpha = 1
        UIView.animateWithDuration(duration, animations: {
            
            fromViewController.view.alpha = 0.5
            
            movingView.transform = CGAffineTransformMakeScale(0.4, 0.4)
            movingView.center = CGPoint(x:90, y: 355)
            
            movingSignature.transform = CGAffineTransformMakeScale(0.4, 0.09)
            movingSignature.center = CGPoint(x:90, y: 355) //mainBackController.messageView.center

            }) { (finished: Bool) -> Void in
                self.finish()
        }
    }

}
