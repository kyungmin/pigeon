//
//  FrontViewController.swift
//  Pigeon
//
//  Created by Kyungmin Kim on 3/14/15.
//  Copyright (c) 2015 Kyungmin Kim. All rights reserved.
//

import UIKit

class FrontViewController: UIViewController,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var navImageView: UIImageView!
    @IBOutlet weak var menuButton: UIButton!

    var picker:UIImagePickerController?=UIImagePickerController()

    @IBOutlet weak var contentView: UIView!
    var contentViewStartingPositionX: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func screenEdgeDidPan(sender: UIScreenEdgePanGestureRecognizer) {
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        
        if (sender.state == UIGestureRecognizerState.Began){
            
            contentViewStartingPositionX = contentView.frame.origin.x
            
            
            
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            
            contentView.frame.origin.x = contentViewStartingPositionX + translation.x
            
            
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            
            if ( velocity.x > 0) {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    
                    self.contentView.frame.origin.x = 270
                    
                    }, completion: { (finished:Bool) -> Void in
                        
                        var panGesture = UIPanGestureRecognizer(target: self, action: "contentViewDidPan:")
                        self.contentView.addGestureRecognizer(panGesture)
                        
                        
                })
                
                
                
            } else {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.contentView.frame.origin.x = 0
                })
            }
            
        }

    }
    
    @IBAction func menuButtonDidPress(sender: AnyObject) {
        if (contentView.frame.origin.x == 0){
            UIView.animateWithDuration(0.2, animations: { () -> Void in
            
                self.contentView.frame.origin.x = 270
            
                }, completion: { (finished:Bool) -> Void in
                
                    var panGesture = UIPanGestureRecognizer(target: self, action: "contentViewDidPan:")
                    self.contentView.addGestureRecognizer(panGesture)
                
                
            })
        } else {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.contentView.frame.origin.x = 0
            })

        }
        
    }
    
    @IBAction func contentViewDidPan(sender: UIPanGestureRecognizer) {
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        
        if (sender.state == UIGestureRecognizerState.Began){
            
            contentViewStartingPositionX = contentView.frame.origin.x
            
            
            
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            
            contentView.frame.origin.x = contentViewStartingPositionX + translation.x
            
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            
            if ( velocity.x > 0) {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    
                    self.contentView.frame.origin.x = 270
                    
                    }, completion: { (finished:Bool) -> Void in
                        
                        
                })
                
            } else {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.contentView.frame.origin.x = 0
                })
            }
            
        }

    }
    
    @IBAction func photoButtonDidPress(sender: AnyObject) {
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
        photoView.image = selectedImage
 
        
        picker .dismissViewControllerAnimated(true, completion: nil)
        //sets the selected image to image view
        //photoView.image=info[UIImagePickerControllerOriginalImage] as? UIImage
        
        
        photoButton.hidden = true
        menuButton.hidden = true
        navImageView.image = UIImage(named:"nav_bar_back_pigeon_next")
        
        //remove ScreenEdgePanGesture
        if let recognizers = contentView.gestureRecognizers {
            for recognizer in recognizers {
                contentView.removeGestureRecognizer(recognizer as UIGestureRecognizer)
            }
        }
        
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!)
    {
        println("picker cancel.")
        picker .dismissViewControllerAnimated(true, completion: nil)
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
