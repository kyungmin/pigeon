//
//  BackAddressViewController.swift
//  Pigeon
//
//  Created by Kyungmin Kim on 3/14/15.
//  Copyright (c) 2015 Kyungmin Kim. All rights reserved.
//

import UIKit

class BackAddressViewController: UIViewController {

    @IBOutlet weak var addressEditTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressEditTextView.becomeFirstResponder()
        addressEditFormat()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var destinationViewController = segue.destinationViewController as BackViewController
        
        destinationViewController.inputAddress = addressEditTextView.text
    }
    @IBAction func onTapDone(sender: AnyObject) {
        performSegueWithIdentifier("finishAddressEditSegue", sender: nil)
    }



    
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
