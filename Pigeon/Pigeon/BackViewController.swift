//
//  BackViewController.swift
//  Pigeon
//
//  Created by Kyungmin Kim on 3/14/15.
//  Copyright (c) 2015 Kyungmin Kim. All rights reserved.
//

import UIKit

class BackViewController: UIViewController, InputMessageDelegate, InputAddressDelegate, InputSignatureDelegate, UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    var picker:UIImagePickerController?=UIImagePickerController()
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var messageView: DashedBorderView!
    @IBOutlet weak var addressView: DashedBorderView!
    
    @IBOutlet weak var signatureImage: UIImageView!
    @IBOutlet weak var stampImage: UIImageView!
    

    //Custom Transition
    var messageInputTransition: MessageInputTransition!
    var addressInputTransition: AddressInputTransition!
    var signatureInputTransition: SignatureInputTransition!
    var duration: NSTimeInterval! = 0.3
    
      override func viewDidLoad() {
        super.viewDidLoad()

        addressFormat()
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
   
    
    //DELEGATES
    func userEnterMessage(info:NSString) {
        if info == " " {
            messageTextView.text = "Message"
        } else {
            messageTextView.text = info
        }
    }
    func userEnterAddress(info:NSString) {
        if info == " " {
            addressTextView.text = "Address"
        } else {
            addressTextView.text = info
        }
    }
    func userSign(info: UIImage){
        signatureImage.image = info
        signatureImage.alpha = 0.8
    }
    
    //ACTIONS
    @IBAction func onMessageTap(sender: UITapGestureRecognizer) {
        performSegueWithIdentifier("editMessageSegue", sender: nil)
    }
    @IBAction func onAddressTap(sender: UITapGestureRecognizer) {
        performSegueWithIdentifier("editAddressSegue", sender: nil)
    }
    @IBAction func onSignatureTap(sender: AnyObject) {
       performSegueWithIdentifier("editSignatureSegue", sender: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //inputTransition = MessageInputTransition()
        //inputTransition.duration = 0.3
        
        if segue.identifier == "editMessageSegue"{
            let inputMessageVC = segue.destinationViewController as BackMessageViewController
            inputMessageVC.delegate = self
            
            messageInputTransition = MessageInputTransition()
            messageInputTransition.duration = duration
            inputMessageVC.modalPresentationStyle = UIModalPresentationStyle.Custom
            inputMessageVC.transitioningDelegate = messageInputTransition
            
        }
        else if segue.identifier == "editAddressSegue" {
            let inputAddressVC = segue.destinationViewController as BackAddressViewController
            inputAddressVC.delegate = self
            
            addressInputTransition = AddressInputTransition()
            addressInputTransition.duration = duration
            inputAddressVC.modalPresentationStyle = UIModalPresentationStyle.Custom
            inputAddressVC.transitioningDelegate = addressInputTransition
        }
        else if segue.identifier == "editSignatureSegue" {
            let inputSignatureVC = segue.destinationViewController as SignatureViewController
            inputSignatureVC.delegate = self
            
            signatureInputTransition = SignatureInputTransition()
            signatureInputTransition.duration = duration
            inputSignatureVC.modalPresentationStyle = UIModalPresentationStyle.Custom
            inputSignatureVC.transitioningDelegate = signatureInputTransition
        }
        
        
    }
    //Swipe
    @IBAction func didPressBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func toFront(sender: UIPanGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.Began) {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

    //next
    @IBAction func onTapNext(sender: AnyObject) {
        performSegueWithIdentifier("toPaymentSegue", sender: nil)
    }


    //FORMATTING
    func addressFormat() {
        var inputLength = countElements(addressTextView.text)
        
        let textColor: UIColor = UIColor(red: 170/256, green: 170/256, blue: 170/256, alpha: 1)
        var style = NSMutableParagraphStyle ()
        style.lineSpacing  = 8;
        var myMutableString = NSMutableAttributedString(string:addressTextView.text , attributes: [NSFontAttributeName:UIFont(name: "BradleyHandITCTT-Bold", size: 10.0)!])
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: textColor, range: NSRange(location:0,length: inputLength))
        myMutableString.addAttributes([NSParagraphStyleAttributeName : style],range: NSRange(location:0,length: inputLength))
        
        addressTextView.attributedText = myMutableString
        
    }
    
    
    //PHOTO Picker (stamp)
    @IBAction func stampTap(sender: UITapGestureRecognizer) {
        var alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openCamera()
        }
        var gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openGallary()
        }
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
            {
                UIAlertAction in
        }
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the actionsheet
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    func openCamera(){
        picker!.delegate = self
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    func openGallary(){
        picker!.delegate = self
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(picker!, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!)
    {
        
        let selectedImage : UIImage = info[UIImagePickerControllerOriginalImage] as UIImage
        stampImage.image = selectedImage
        
        picker .dismissViewControllerAnimated(true, completion: nil)
        //sets the selected image to image view
        //photoView.image=info[UIImagePickerControllerOriginalImage] as? UIImage

    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController!)
    {
        println("picker cancel.")
        picker .dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
/*---------------IGNORE BELOW-------------------*/
    
//    //CUSTOM TRANSITION
//    //CUSTOM View Controller Transitions
//    //1. Prepare for Seque (see above)
//    //2. Add delegates on top
//    //3. Add func: forPresented, forDissmissed
//    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
//        isPresenting = true
//        return self
//    }
//    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
//        isPresenting = false
//        return self
//    }
//    //4. Add func to actually controls transitionDuration (with global var, viewDidload assign), animateTransition
//    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
//        // Set same value here and in animateTransition below
//        return duration
//    }
//    
//    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
//        println("animating transition")
//        var containerView = transitionContext.containerView()
//        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
//        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
//        
//        var inputMessage = toViewController as BackMessageViewController
//        inputMessage.doneButton.hidden = true
//        
//        var mainBackController = fromViewController as BackViewController
//        var movingView = inputMessage.containerView
//        
//        movingView.frame = inputMessage.containerView.frame
//        
//        if (isPresenting) {
//            containerView.addSubview(toViewController.view)
//            toViewController.view.alpha = 0
//            
//            UIView.animateWithDuration(0.4, animations: { () -> Void in
//                toViewController.view.alpha = 1
//                }) { (finished: Bool) -> Void in
//                    transitionContext.completeTransition(true)
//            }
//            
//            
//        } else {
//            UIView.animateWithDuration(0.4, animations: { () -> Void in
//                fromViewController.view.alpha = 0
//                }) { (finished: Bool) -> Void in
//                    transitionContext.completeTransition(true)
//                    fromViewController.view.removeFromSuperview()
//            }
//        }
//    }
    
//    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
////        println("animating transition")
////        
////        var containerView = transitionContext.containerView() //create a main container view
////        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
////        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
////        
////        if (isPresenting) {
//            
////            /* Additional I: temp UIImageView, add to window, create a view animation */
////            newImageRect = CGRectMake(selectedImageViewPt.x, selectedImageViewPt.y + scrollView.frame.origin.y, selectedImageViewSize.width, selectedImageViewSize.height);
////            newImgView = UIImageView(frame: newImageRect)
////            newImgView.contentMode = .ScaleAspectFill
////            newImgView.clipsToBounds = true
////            newImgView.image = selectedImage
////            
////            containerView.addSubview(newImgView)
////            newImgView.alpha = 0 //Twin
////            
////            containerView.addSubview(toViewController.view) //ADD this to/subview to main container view
////            toViewController.view.alpha = 0 //TO
////            
////            UIView.animateWithDuration(1, animations: { () -> Void in //SET visible ALPHA, SIZE
////                
////                self.newImgView.alpha = 1 //Twin
////                
////                self.newImgView.center = CGPoint(x: 160.0, y: 284.0)
////                self.newImgView.frame = CGRect(x: 0, y: 44, width: 320, height: 480)
////                
////                delay(0.5, { () -> () in
////                    UIView.animateWithDuration(0.7, animations: { () -> Void in
////                        toViewController.view.alpha = 1 //TO
////                    })
////                })
////                
////                }) { (finished: Bool) -> Void in
////                    transitionContext.completeTransition(true) //mark trans as done
////                }
//            
//            var inputMessage = fromViewController as BackMessageViewController
//            inputMessage.doneButton.hidden = true
//            
//            var mainBackController = toViewController as BackViewController
//            
//            var movingView = inputMessage.containerView
//            movingView.frame = inputMessage.containerView.frame
//            containerView.addSubview(movingView)
//            
//            
//            toViewController.view.alpha = 0
//            UIView.animateWithDuration(duration, animations: {
//                toViewController.view.alpha = 1
//                
//                movingView.center = mainBackController.messageView.center
//                movingView.transform = CGAffineTransformMakeScale(0.45, 0.45)
//                
//                }) { (finished: Bool) -> Void in
//                   // self.finish()
//                    movingView.removeFromSuperview()
//            }
//            
//        }
//        
//        //Dismissing
//        else {
//            
////            fromViewController.view.alpha = 1 //FROM
////            UIView.animateWithDuration(1, animations: { () -> Void in //SET invisible ALPHA, SIZE, once done: remove from main
////                fromViewController.view.alpha = 0 //FROM
////                
////                self.newImgView.alpha = 0 //invisible
////                
////                self.newImgView.center = CGPoint(x: self.selectedImageViewPt.x, y: self.selectedImageViewPt.y)
////                self.newImgView.frame = self.newImageRect
////                
////                }) { (finished: Bool) -> Void in
////                    transitionContext.completeTransition(true) //mark trans as done
////                    fromViewController.view.removeFromSuperview() //REMOVE 2nd/from view from super/main container view
////                    
////                    self.newImgView.removeFromSuperview()
////            }
//        }
//    }
    
}
