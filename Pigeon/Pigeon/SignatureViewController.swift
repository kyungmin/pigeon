//
//  SignatureViewController.swift
//  Pigeon
//
//  Created by Nissana Akranavaseri on 3/19/15.
//  Copyright (c) 2015 Kyungmin Kim. All rights reserved.
//

import UIKit

protocol InputSignatureDelegate {
    func userSign(info: UIImage)
}

class SignatureViewController: UIViewController {

    var delegate: InputSignatureDelegate? = nil
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var signatureView: DrawSignatureView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var line: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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


    @IBAction func onTapDone(sender: AnyObject) {
        if delegate != nil {
            let information: UIImage = signatureView.getSignature()
            delegate!.userSign(information)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func clearSignature(sender: AnyObject) {
        signatureView.clearSignature()
    }
}
