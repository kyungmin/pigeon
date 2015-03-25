//
//  PaymentViewController.swift
//  Pigeon
//
//  Created by Kyungmin Kim on 3/14/15.
//  Copyright (c) 2015 Kyungmin Kim. All rights reserved.
//

import UIKit
import Foundation


class PaymentViewController: UIViewController, CardIOPaymentViewControllerDelegate
{
    @IBOutlet weak var paymentImageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var scancardView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var placeorderButton: UIButton!
    
    var cardIOVC: CardIOPaymentViewController!
    var sublayerTop: CALayer!
    var sublayerBottom: CALayer!
    
    var inputLength: Int!
    var input: String!
    var buttonName: String!
    let tealColor: UIColor = UIColor(red: 111/256, green: 188/256, blue: 196/256, alpha: 1)
    let paleGraylColor: UIColor = UIColor(red: 256/256, green: 256/256, blue: 256/256, alpha: 0.4)
    //#6FBCC4, 111 188 196
    
    //UIDynamic
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        CardIOUtilities.preload()
        editButton.hidden = true
        placeorderButton.hidden = true
        cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        
        
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

    @IBAction func onTapBack(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //SCAN Card
    @IBAction func onTapScancard(sender: AnyObject) {
        //UIDynamic
        //gravity.addItem(scancardView)
        

        sublayerTop = CALayer()
        sublayerTop.frame = CGRectMake(0,44,320,35)
        sublayerTop.backgroundColor = UIColor.whiteColor().CGColor
        cardIOVC.navigationBar.layer.addSublayer(sublayerTop)

        sublayerBottom = CALayer()
        sublayerBottom.frame = CGRectMake(0,70,320,500)
        sublayerBottom.backgroundColor = paleGraylColor.CGColor
        cardIOVC.navigationBar.layer.addSublayer(sublayerBottom)
        
        cardIOVC.modalPresentationStyle = .FormSheet
        cardIOVC.view.tintColor = tealColor
        UIBarButtonItem.appearance().title = "            "
        
        cardIOVC.navigationBar.backgroundColor = UIColor.clearColor()
        cardIOVC.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Symbol", size: 0.1)!]
        //UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName:UIFont(name: "Montserrat-Regular", size: 13.0)!], forState: UIControlState.Normal)
    
        var imageBG = UIImage(named: "nav_bar_cancel_pigeon_finish") as UIImage?
        cardIOVC.navigationBar.setBackgroundImage(imageBG, forBarMetrics: UIBarMetrics.Default)
        

        //UIDynamic
        animator = UIDynamicAnimator(referenceView: self.view) //self.view)
        gravity = UIGravityBehavior()
        gravity.gravityDirection = CGVectorMake(0, 2)
        animator.addBehavior(gravity)
        
        
        collision = UICollisionBehavior()
        animator.addBehavior(collision)
        collision.addBoundaryWithIdentifier("ground", fromPoint: CGPointMake(0, self.view.frame.height * 2 ), toPoint: CGPointMake(self.view.frame.width, self.view.frame.height * 2))

        
        gravity.addItem(scancardView)
        collision.addItem(scancardView)

        delay(0.5, { () -> () in
            self.presentViewController(self.cardIOVC, animated: true, completion: nil)

        })

        delay(1, { () -> () in
            self.gravity.gravityDirection = CGVectorMake(0, -1)
            self.animator.addBehavior(self.gravity)
            self.gravity.addItem(self.scancardView)
            
            self.animator.addBehavior(self.collision)
            self.collision.addBoundaryWithIdentifier("ground", fromPoint: CGPointMake(0, 60 ), toPoint: CGPointMake(self.view.frame.width, 60))
            self.collision.addItem(self.scancardView)

        })

    }
    
    func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
        sublayerTop.removeFromSuperlayer()
        sublayerBottom.removeFromSuperlayer()
    }
    func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            scancardView.hidden = true
            let str = NSString(format: " %@\n %02lu/%lu\n %@", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
            
            resultLabel.text = str
            input = str
            inputLength = str.length
            resultFormat()
        }
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
        editButton.hidden = false
        placeorderButton.hidden = false
        paymentImageView.alpha = 1
        sublayerTop.removeFromSuperlayer()
        sublayerBottom.removeFromSuperlayer()
    }
    
    //FORMATTING
    func resultFormat() {
        
        let textColor: UIColor = UIColor(red: 111/256, green: 188/256, blue: 196/256, alpha: 1) //#6FBCC4, 111 188 196
        var style = NSMutableParagraphStyle ()
        style.lineSpacing  = 26;
        style.alignment = NSTextAlignment.Right;
        var myMutableString = NSMutableAttributedString(string: input, attributes: [NSFontAttributeName:UIFont(name: "Montserrat-Regular", size: 16.0)!])
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: textColor, range: NSRange(location:0,length: inputLength))
        myMutableString.addAttributes([NSParagraphStyleAttributeName : style],range: NSRange(location:0,length:inputLength))
        resultLabel.attributedText = myMutableString
    }
}
