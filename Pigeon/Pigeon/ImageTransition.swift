//
//  ImageTransition.swift
//  Pigeon
//
//  Created by Kyungmin Kim on 3/17/15.
//  Copyright (c) 2015 Kyungmin Kim. All rights reserved.
//

import UIKit

class ImageTransition: BaseTransition {
    
    override func presentTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        toViewController.view.alpha = 0
        UIView.animateWithDuration(duration, animations: {
            toViewController.view.alpha = 1
            }) { (finished: Bool) -> Void in
                self.finish()
        }
    }
    
    override func dismissTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        var fromVC = fromViewController as FontViewController
        var toVC = toViewController as FrontEditViewController

        toVC.addFont(fromVC.selectedFont)
        fromViewController.view.alpha = 1

        UIView.animateWithDuration(duration, animations: {
            fromViewController.view.alpha = 0
            }) { (finished: Bool) -> Void in
                self.finish()
        }
    }
}
