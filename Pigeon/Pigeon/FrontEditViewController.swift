//
//  FrontEditViewController.swift
//  Pigeon
//
//  Created by Kyungmin Kim on 3/17/15.
//  Copyright (c) 2015 Kyungmin Kim. All rights reserved.
//

import UIKit

class FrontEditViewController: UIViewController, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var scale: CGFloat! = 1
    var translation: CGPoint! = CGPoint(x: 0.0, y: 0.0)
    var originalImageFrame: CGRect!
    var originalImageCenter: CGPoint!
    var currentSelection: AnyObject!
    var imageTransition: ImageTransition!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalImageFrame = imageView.frame
        originalImageCenter = imageView.center
        scrollView.contentSize = imageView.frame.size
    }

    @IBAction func didPinchImage(sender: UIPinchGestureRecognizer) {
        scale = sender.scale
        
        if (sender.state == UIGestureRecognizerState.Changed) {
            imageView.transform = CGAffineTransformScale(sender.view!.transform, scale, scale)
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            if (sender.view!.frame.size.width < originalImageFrame.size.width) {
                imageView.transform = CGAffineTransformMakeScale(1, 1)
            }
        }
        sender.scale = 1
    }
    
    @IBAction func didPanImage(sender: UIPanGestureRecognizer) {
        translation = sender.translationInView(view)
        
        if (sender.state == UIGestureRecognizerState.Began) {
            originalImageCenter = imageView.center
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            imageView.transform = CGAffineTransformScale(sender.view!.transform, scale, scale)
            imageView.center = CGPoint(x: originalImageCenter.x + translation.x, y: originalImageCenter.y + translation.y)
        }
    }

    @IBAction func didPanLabel(sender: UIPanGestureRecognizer) {
        translation = sender.translationInView(view)
        
        var label = sender.view as UILabel
        
        if (sender.state == UIGestureRecognizerState.Began) {
            originalImageCenter = sender.view!.center
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            label.textColor = UIColor.blueColor()
            label.transform = CGAffineTransformScale(sender.view!.transform, scale, scale)
            label.center = CGPoint(x: originalImageCenter.x + translation.x, y: originalImageCenter.y + translation.y)
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            label.textColor = UIColor.whiteColor()
            imageView.userInteractionEnabled = true
        }
    }

    @IBAction func didTapLabel(sender: UIPanGestureRecognizer) {
        var label = sender.view as UILabel
        label.textColor = UIColor.blueColor()
        currentSelection = label
        addPanGestureRecognizer(label)
        label.userInteractionEnabled = true
        imageView.userInteractionEnabled = false
    }
    
    @IBAction func didPressFontButton(sender: AnyObject) {
        performSegueWithIdentifier("fontSegue", sender: self)
    }
    
    func addFont(selectedFont: String) {
        var newLabel = UILabel(frame: CGRectMake(0, 0, 200, 50))
        newLabel.font = UIFont(name: selectedFont, size: CGFloat(50))
        newLabel.text = "Font 1"
        newLabel.textColor = UIColor.whiteColor()
        newLabel.textAlignment = .Center
        newLabel.userInteractionEnabled = true
        newLabel.center = imageView.center
        addTapGestureRecognizer(newLabel)

        scrollView.addSubview(newLabel)
    }
    
    func addTapGestureRecognizer(target :AnyObject) {
        var tapGesture = UITapGestureRecognizer(target: self, action: "didTapLabel:")
        tapGesture.delegate = self
        target.addGestureRecognizer(tapGesture)
    }

    func addPanGestureRecognizer(target :AnyObject) {
        var panGesture = UIPanGestureRecognizer(target: self, action: "didPanLabel:")
        panGesture.delegate = self
        target.addGestureRecognizer(panGesture)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var toViewController = segue.destinationViewController as FontViewController
        toViewController.image = imageView.image
        toViewController.modalPresentationStyle = UIModalPresentationStyle.Custom

        imageTransition = ImageTransition()
        imageTransition.duration = 0.3
        toViewController.transitioningDelegate = imageTransition
    }


}
