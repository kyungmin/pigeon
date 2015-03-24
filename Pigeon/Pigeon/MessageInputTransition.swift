//
//  ImageTransition.swift
//  Pigeon
//
//  Created by Nissana Akranavaseri on 3/18/15.
//  Copyright (c) 2015 Kyungmin Kim. All rights reserved.
//

import UIKit

class MessageInputTransition: BaseTransition {
   
    
    override func presentTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        //to
        var inputMessage = toViewController as BackMessageViewController

        toViewController.view.alpha = 0
        inputMessage.containerView.transform = CGAffineTransformMakeScale(0, 0)
        
        UIView.animateWithDuration(duration, animations: {
            toViewController.view.alpha = 1
            inputMessage.containerView.transform = CGAffineTransformMakeScale(1, 1)
            
            }) { (finished: Bool) -> Void in
                self.finish()
        }
        
    }
    
    override func dismissTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        var inputMessage = fromViewController as BackMessageViewController
        inputMessage.doneButton.hidden = true

        //var mainBackController = toViewController as BackViewController -- ERROR

        var movingView = inputMessage.containerView
        movingView.frame = inputMessage.containerView.frame
        containerView.addSubview(movingView)
        
        fromViewController.view.alpha = 1
        UIView.animateWithDuration(duration, animations: {
            
            movingView.alpha = 0.3
            movingView.center = CGPoint(x: 93, y: 256) //mainBackController.messageView.center
            movingView.transform = CGAffineTransformMakeScale(0.5, 0.5)
            
            }) { (finished: Bool) -> Void in
                self.finish()
        }
    }
    
}
