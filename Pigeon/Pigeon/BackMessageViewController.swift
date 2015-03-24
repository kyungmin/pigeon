//
//  BackMessageViewController.swift
//  Pigeon
//
//  Created by Kyungmin Kim on 3/14/15.
//  Copyright (c) 2015 Kyungmin Kim. All rights reserved.
//

import UIKit

protocol InputMessageDelegate {
    func userEnterMessage(info:NSString)
}

class BackMessageViewController: UIViewController {
    
    var delegate: InputMessageDelegate? = nil
    //var inputTransition: MessageInputTransition!
    
    @IBOutlet weak var messageEditTextView: UITextView!
    @IBOutlet weak var containerView: UIView! //not used
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageEditTextView.becomeFirstResponder()
        messageEditFormat()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        var destinationViewController = segue.destinationViewController as BackViewController
//        destinationViewController.inputMessage = messageEditTextView.text
//        println("Back message view controller: \(destinationViewController.inputMessage)")
//        inputTransition = MessageInputTransition()
//        inputTransition.duration = 0.3
//        
//        destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
//        destinationViewController.transitioningDelegate = inputTransition
//        
//    }
    
    
    @IBAction func onTapDone(sender: AnyObject) {
        //performSegueWithIdentifier("finishMessageEditSegue", sender: nil)
        //navigationController!.popViewControllerAnimated(true)
        
        if delegate != nil {
            let information: NSString = messageEditTextView.text
            
            delegate!.userEnterMessage(information)
            dismissViewControllerAnimated(true, completion: nil)
            //self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    //FORMATTING
    func messageEditFormat() {
        
        let textColor: UIColor = UIColor(red: 96/256, green: 94/256, blue: 97/256, alpha: 1) //#605E61, 96 94 97
        
        var style = NSMutableParagraphStyle ()
            style.lineSpacing  = 30;
        var myMutableString = NSMutableAttributedString(string: " ", attributes: [NSFontAttributeName:UIFont(name: "BradleyHandITCTT-Bold", size: 18.0)!])
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: textColor, range: NSRange(location:0,length:1))
        myMutableString.addAttributes([NSParagraphStyleAttributeName : style],range: NSRange(location:0,length:1))
        
        messageEditTextView.attributedText = myMutableString
    }

}
