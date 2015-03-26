//
//  FrontEditViewController.swift
//  Pigeon
//
//  Created by Kyungmin Kim on 3/17/15.
//  Copyright (c) 2015 Kyungmin Kim. All rights reserved.
//

import UIKit

class FrontEditViewController: UIViewController, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var frontBackground: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buttonGroup: UIView!
    
    var photoScale: CGFloat! = 1
    var labelScale: CGFloat! = 1
    var translation: CGPoint! = CGPoint(x: 0.0, y: 0.0)
    var location: CGPoint! = CGPoint(x: 0.0, y: 0.0)
    var originalImageFrame: CGRect!
    var originalImageCenter: CGPoint!
    var currentSelection: AnyObject!
    var imageTransition: ImageTransition!
    var textField: UITextField!
    var newSticker: UIImageView!
    var stickerNames: [String]!
    var segues: [String!] = []
    var originalImageY: CGFloat!
    
    //create a variable to catch the image passing from the previous view controller
    var photoImage:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalImageY = scrollView.center.y
        
        //assign selected image to imageView
        imageView.image = photoImage
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        originalImageFrame = imageView.frame
        originalImageCenter = imageView.center
        scrollView.contentSize = imageView.frame.size
        
        segues = ["fontSegue", "stickerSegue", "templateSegue"]
        stickerNames = ["sticker_heart_highlighted", "sticker_plane_highlighted", "sticker_lips_highlighted"]
        
        buttonGroup.center.y = buttonGroup.center.y + buttonGroup.frame.height
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

    }
    
    override func viewDidAppear(animated: Bool) {
        showMenu()
    }

    func keyboardWillShow(notification: NSNotification!) {
        var userInfo = notification.userInfo!
        
        var kbSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue().size
        var durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSNumber
        var animationDuration = durationValue.doubleValue
        var curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey] as NSNumber
        var animationCurve = curveValue.integerValue
        
        UIView.animateWithDuration(animationDuration, delay: 0.0, options: UIViewAnimationOptions(UInt(animationCurve << 16)), animations: {
            
            self.scrollView.center.y = 200
            self.frontBackground.center.y -= (self.originalImageY - 200)
            }, completion: nil)
    }
    
    func keyboardWillHide(notification: NSNotification!) {
        var userInfo = notification.userInfo!
        
        // Get the keyboard height and width from the notification
        // Size varies depending on OS, language, orientation
        var kbSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue().size
        var durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSNumber
        var animationDuration = durationValue.doubleValue
        var curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey] as NSNumber
        var animationCurve = curveValue.integerValue
        
        UIView.animateWithDuration(animationDuration, delay: 0.0, options: UIViewAnimationOptions(UInt(animationCurve << 16)), animations: {
            self.scrollView.center.y = self.originalImageY
            self.frontBackground.center.y += (self.originalImageY - 200)
            }, completion: nil)
    }

    @IBAction func didPinchImage(sender: UIPinchGestureRecognizer) {
        photoScale = sender.scale
        var target = sender.view!
        
        if (sender.state == UIGestureRecognizerState.Changed) {
            target.transform = CGAffineTransformScale(target.transform, photoScale, photoScale)
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            if (target.frame.size.width < originalImageFrame.size.width) {
                target.transform = CGAffineTransformMakeScale(1, 1)
            }
            checkImageBoundary()
        }
        sender.scale = 1
    }

    
    @IBAction func didPinchLabel(sender: UIPinchGestureRecognizer) {
        imageView.userInteractionEnabled = false
        
        if sender.scale >= 1 {
            labelScale = 1
        } else {
            labelScale = -1
        }

        var label = sender.view as UILabel
        
        if (sender.state == UIGestureRecognizerState.Changed) {

            label.frame.size = CGSize(width: label.frame.width + labelScale, height: label.frame.height + labelScale)
            label.font = label.font.fontWithSize(label.font.pointSize + labelScale)
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            imageView.userInteractionEnabled = true
        }
        sender.scale = 1
    }
    
    @IBAction func didPanImage(sender: UIPanGestureRecognizer) {
        translation = sender.translationInView(view)
        location = sender.locationInView(view)
        //println(sender.view)
        
        
        if (sender.state == UIGestureRecognizerState.Began) {
            originalImageCenter = imageView.center
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            imageView.transform = CGAffineTransformScale(sender.view!.transform, photoScale, photoScale)
            imageView.center = CGPoint(x: originalImageCenter.x + translation.x, y: originalImageCenter.y + translation.y)
            
            
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            checkImageBoundary()
            
        }
    }

    @IBAction func didPanLabel(sender: UIPanGestureRecognizer) {
        translation = sender.translationInView(view)
        
        var label = sender.view as UILabel
        
        if (sender.state == UIGestureRecognizerState.Began) {
            originalImageCenter = sender.view!.center
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            label.textColor = UIColor.grayColor()
            label.transform = CGAffineTransformScale(sender.view!.transform, labelScale, labelScale)
            label.center = CGPoint(x: originalImageCenter.x + translation.x, y: originalImageCenter.y + translation.y)
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            label.textColor = UIColor.whiteColor()
            imageView.userInteractionEnabled = true
            
            
        }
    }

    @IBAction func didTapLabel(sender: UIPanGestureRecognizer) {
        var label = sender.view as UILabel
        currentSelection = label
        
        textField = UITextField(frame: CGRect(x: 0, y: 0, width: label.frame.width, height: label.frame.height))
        label.alpha = 0
        textField.center = label.center
        textField.textAlignment = .Center
        textField.text = label.text
        textField.font = label.font
        textField.textColor = UIColor.whiteColor()
        scrollView.addSubview(textField)
        textField.becomeFirstResponder()
        textField.selectedTextRange = textField.textRangeFromPosition(textField.beginningOfDocument, toPosition: textField.endOfDocument)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if textField != nil {
            view.endEditing(true)
            var label = currentSelection as UILabel
            label.text = textField.text
            label.alpha = 1
            textField.removeFromSuperview()
        }
        
        super.touchesBegan(touches, withEvent: event)
    }
    
    func addFont(selectedFont: String) {
        var newLabel = UILabel(frame: CGRectMake(0, 0, 200, 50))
        newLabel.font = UIFont(name: selectedFont, size: CGFloat(20))
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

    func addStickers(selectedStickers: [NSDictionary!]) {
        imageView.userInteractionEnabled = false

        for sticker in selectedStickers {
            var imageName = stickerNames[sticker["tag"] as Int]
            var image = UIImage(named: imageName)
            newSticker = UIImageView(image: image)
            newSticker.center = CGPoint(x: sticker["x"] as CGFloat, y: sticker["y"] as CGFloat)
            scrollView.addSubview(newSticker)
            newSticker.userInteractionEnabled = true
        }
    }

    func setTemplate(selectedWidth: CGFloat) {
        UIView.animateKeyframesWithDuration(0.3, delay: 0, options: nil, animations: { () -> Void in
            self.scrollView.frame.size = CGSize(width: selectedWidth, height: self.scrollView.frame.height)
        }, completion: nil)
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
    
    func checkImageBoundary() {
        if (imageView.frame.origin.x >= 0) {
            imageView.frame.origin.x = 0
        }
        if (imageView.frame.origin.y >= 0) {
            imageView.frame.origin.y = 0
        }
        
        if (imageView.frame.origin.x < 0 && imageView.frame.origin.x + imageView.frame.size.width < scrollView.frame.width) {
            imageView.frame.origin.x = imageView.frame.origin.x + (scrollView.frame.width - (imageView.frame.origin.x + imageView.frame.size.width))
        }
        
        if (imageView.frame.origin.y < 0 && imageView.frame.origin.y + imageView.frame.size.height < scrollView.frame.height) {
            imageView.frame.origin.y = imageView.frame.origin.y + (scrollView.frame.height - (imageView.frame.origin.y + imageView.frame.size.height))
        }

    }
    
    @IBAction func didPressMenu(sender: AnyObject) {
        performSegueWithIdentifier(segues[sender.tag], sender: self)
    }
    
    
    @IBAction func didPressBackButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didPressNextButton(sender: AnyObject) {
        performSegueWithIdentifier("saveFontSegue", sender: self)
    }

    func showMenu() {
        UIView.animateWithDuration(0.4, delay: 0.4, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.4, options: nil, animations: { () -> Void in
            self.buttonGroup.center = CGPoint(x:self.buttonGroup.center.x, y: self.buttonGroup.center.y - self.buttonGroup.frame.height)
            }, completion: nil)
    }
    
    func hideMenu() {
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.4, options: nil, animations: { () -> Void in
            self.buttonGroup.center = CGPoint(x:self.buttonGroup.center.x, y: self.buttonGroup.center.y + self.buttonGroup.frame.height)
            }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        imageTransition = ImageTransition()
        imageTransition.duration = 0.3
        
        var fromViewController = segue.sourceViewController as FrontEditViewController

        if segue.identifier == "fontSegue" {
            var toViewController = segue.destinationViewController as FontViewController
            toViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
            toViewController.transitioningDelegate = imageTransition
        } else if segue.identifier == "stickerSegue" {
            var toViewController = segue.destinationViewController as StickerViewController
            toViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
            toViewController.transitioningDelegate = imageTransition
        } else if segue.identifier == "templateSegue" {
            var toViewController = segue.destinationViewController as TemplateViewController
            toViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
            toViewController.transitioningDelegate = imageTransition
        } else if segue.identifier == "saveFontSegue" {
            hideMenu()
            var toViewController = segue.destinationViewController as FakeFrontViewController
            toViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
            toViewController.transitioningDelegate = imageTransition
        }
    }
}
