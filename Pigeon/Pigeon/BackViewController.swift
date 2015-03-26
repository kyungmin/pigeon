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
    
    @IBAction func didPanView(sender: UIPanGestureRecognizer) {
        var velocity = sender.velocityInView(view)
        
        if (sender.state == UIGestureRecognizerState.Began) {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
