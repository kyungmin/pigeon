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
    var textField: UITextField!
    
    var tabs: [UIViewController]!
    var segues: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalImageFrame = imageView.frame
        originalImageCenter = imageView.center
        scrollView.contentSize = imageView.frame.size
        
        tabs = [FontViewController, StickerViewController, TemplateViewController]
        segues = ["fontSegue", "stickerSegue", "templateSegue"]
    }

    @IBAction func didPinchImage(sender: UIPinchGestureRecognizer) {
        scale = sender.scale
        var target = sender.view!
        
        if (sender.state == UIGestureRecognizerState.Changed) {
            target.transform = CGAffineTransformScale(target.transform, scale, scale)
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            if (target.frame.size.width < originalImageFrame.size.width) {
                target.transform = CGAffineTransformMakeScale(1, 1)
            }
        }
        sender.scale = 1
    }

    
    @IBAction func didPinchLabel(sender: UIPinchGestureRecognizer) {
        imageView.userInteractionEnabled = false
        
        scale = sender.scale
        //TODO: better handle scaling back
        
        var label = sender.view as UILabel
        
        if (sender.state == UIGestureRecognizerState.Changed) {
            label.font = label.font.fontWithSize(label.font.pointSize + scale)
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            imageView.userInteractionEnabled = true
        }
        
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
        currentSelection = label
        
        textField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        label.alpha = 0
        textField.center = label.center
        textField.textAlignment = .Center
        textField.text = label.text
        textField.textColor = UIColor.whiteColor()
        scrollView.addSubview(textField)
        // TODO: enable editing
        // TODO: select all text
    }
    
    @IBAction func didTapBackground(sender: AnyObject) {
        view.endEditing(true)
        var label = currentSelection as UILabel
        label.text = textField.text
        label.alpha = 1
        textField.removeFromSuperview()
    }
    
    func addFont(selectedFont: String) {
        var newLabel = UILabel(frame: CGRectMake(0, 0, 100, 50))
        newLabel.font = UIFont(name: selectedFont, size: CGFloat(50))
        newLabel.text = "Your text"
        newLabel.textColor = UIColor.whiteColor()
        newLabel.textAlignment = .Center
        newLabel.center = imageView.center
        newLabel.userInteractionEnabled = true
        imageView.userInteractionEnabled = false
        currentSelection = newLabel

        addTapGestureRecognizer(newLabel)
        addPanGestureRecognizer(newLabel)
        addPinchGestureRecognizer(newLabel)
        
        scrollView.addSubview(newLabel)
    }

    // scaling text
    func addPinchGestureRecognizer(target :AnyObject) {
        var pinchGesture = UIPinchGestureRecognizer(target: self, action: "didPinchLabel:")
        pinchGesture.delegate = self
        target.addGestureRecognizer(pinchGesture)
    }

    // editing text
    func addTapGestureRecognizer(target :AnyObject) {
        var tapGesture = UITapGestureRecognizer(target: self, action: "didTapLabel:")
        tapGesture.delegate = self
        target.addGestureRecognizer(tapGesture)
    }

    // moving text
    func addPanGestureRecognizer(target :AnyObject) {
        var panGesture = UIPanGestureRecognizer(target: self, action: "didPanLabel:")
        panGesture.delegate = self
        target.addGestureRecognizer(panGesture)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didPressFontButton(sender: AnyObject) {
        performSegueWithIdentifier("fontSegue", sender: self)
    }
    
    @IBAction func didPressStickerButton(sender: AnyObject) {
        performSegueWithIdentifier("stickerSegue", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var toViewController = segue.destinationViewController as FontViewController
        toViewController.modalPresentationStyle = UIModalPresentationStyle.Custom

        imageTransition = ImageTransition()
        imageTransition.duration = 0.3
        toViewController.transitioningDelegate = imageTransition
    }


}
