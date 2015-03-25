//
//  AddressInputTransition.swift
//  Pigeon
//
//  Created by Nissana Akranavaseri on 3/18/15.
//  Copyright (c) 2015 Kyungmin Kim. All rights reserved.
//

import UIKit

class AddressInputTransition: BaseTransition {
    
    override func presentTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        var inputAddress = toViewController as BackAddressViewController
        toViewController.view.alpha = 0
        inputAddress.containerView.transform = CGAffineTransformMakeScale(0, 0)

        toViewController.view.alpha = 0
        UIView.animateWithDuration(duration, animations: {
            toViewController.view.alpha = 1
            inputAddress.containerView.transform = CGAffineTransformMakeScale(1, 1)
            
            }) { (finished: Bool) -> Void in
                self.finish()

        }
    }
    
    override func dismissTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        var inputAddress = fromViewController as BackAddressViewController
        inputAddress.doneButton.hidden = true
        
        //var mainBackController = toViewController as BackViewController -- ERROR
        
        var movingView = inputAddress.containerView
        movingView.frame = inputAddress.containerView.frame
        containerView.addSubview(movingView)
        
        fromViewController.view.alpha = 1
        UIView.animateWithDuration(duration, animations: {
            
            fromViewController.view.alpha = 0.5
            movingView.alpha = 0.3
            movingView.center = CGPoint(x: 220, y: 280) //mainBackController.messageView.center
            movingView.transform = CGAffineTransformMakeScale(0.45, 0.45)
            
            }) { (finished: Bool) -> Void in
                self.finish()
        }
    }
    
}
