//
//  FakeFrontViewController.swift
//  Pigeon
//
//  Created by Wanting Huang on 3/20/15.
//  Copyright (c) 2015 Kyungmin Kim. All rights reserved.
//

import UIKit

class FakeFrontViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapImage(sender: AnyObject) {
        performSegueWithIdentifier("backToFrontEditSegue", sender: self)
    }
    
    @IBAction func didPanView(sender: UIPanGestureRecognizer) {
        var velocity = sender.velocityInView(view)
        
        if (sender.state == UIGestureRecognizerState.Began) {
            performSegueWithIdentifier("swipeBackSegue", sender: self)
        }
    }
    
    @IBAction func backButtonDidPress(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
