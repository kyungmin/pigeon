//
//  BackAddressViewController.swift
//  Pigeon
//
//  Created by Kyungmin Kim on 3/14/15.
//  Copyright (c) 2015 Kyungmin Kim. All rights reserved.
//

import UIKit

protocol InputAddressDelegate {
    func userEnterAddress(info:NSString)
}

class BackAddressViewController: UIViewController {

    var delegate: InputAddressDelegate? = nil
    
    @IBOutlet weak var addressEditTextView: UITextView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addressEditTextView.becomeFirstResponder()
        addressEditFormat()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        var destinationViewController = segue.destinationViewController as BackViewController
//        destinationViewController.inputAddress = addressEditTextView.text
//        
//        inputTransition = AddressInputTransition()
//        inputTransition.duration = 0.3
//        
//        destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
//        destinationViewController.transitioningDelegate = inputTransition
//    }
    @IBAction func onTapDone(sender: AnyObject) {
        //performSegueWithIdentifier("finishAddressEditSegue", sender: nil)
        //navigationController!.popViewControllerAnimated(true)
        if delegate != nil {
            let information: NSString = addressEditTextView.text
            
            delegate!.userEnterAddress(information)
            dismissViewControllerAnimated(true, completion: nil)
            //self.navigationController?.popViewControllerAnimated(true)
        }
    }



     //FORMATTING
     func addressEditFormat() {
        
        let textColor: UIColor = UIColor(red: 96/256, green: 94/256, blue: 97/256, alpha: 1) //#605E61, 96 94 97
        
        var style = NSMutableParagraphStyle ()
            style.lineSpacing  = 40;
        var myMutableString = NSMutableAttributedString(string: " ", attributes: [NSFontAttributeName:UIFont(name: "BradleyHandITCTT-Bold", size: 18.0)!])
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: textColor, range: NSRange(location:0,length:1))
        myMutableString.addAttributes([NSParagraphStyleAttributeName : style],range: NSRange(location:0,length:1))
        
        addressEditTextView.attributedText = myMutableString

    }
}
