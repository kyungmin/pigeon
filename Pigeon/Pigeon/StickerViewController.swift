//
//  StickerViewController.swift
//  Pigeon
//
//  Created by Kyungmin Kim on 3/14/15.
//  Copyright (c) 2015 Kyungmin Kim. All rights reserved.
//

import UIKit

class StickerViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var tray: UIButton!
    var selectedStickers: [UIImageView!] = []
    var newStickerView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didPanSticker(sender: UIPanGestureRecognizer) {
        var location = sender.locationInView(view)
        var translation = sender.translationInView(view)
        if (sender.state == UIGestureRecognizerState.Began) {
            var imageView = sender.view as UIImageView

            newStickerView = UIImageView(image: imageView.image)
            newStickerView.center = imageView.center
            newStickerView.userInteractionEnabled = true

            selectedStickers.append(newStickerView)
            view.addSubview(newStickerView)
            
            newStickerView.transform = CGAffineTransformMakeScale(1.2, 1.2)
            
            
            var panGesture = UIPanGestureRecognizer(target: self, action: "didPanNewSticker:")
            panGesture.delegate = self
            newStickerView.addGestureRecognizer(panGesture)
        }
        else if (sender.state == UIGestureRecognizerState.Changed) {
            newStickerView.center = location
            newStickerView.transform = CGAffineTransformMakeScale(1.2, 1.2)
            
            
            if (newStickerView.center.y > tray.frame.origin.y) {
                newStickerView.center.y += tray.frame.origin.y
            }
            
        }
        else if (sender.state == UIGestureRecognizerState.Ended) {
            newStickerView.transform = CGAffineTransformMakeScale(1.0, 1.0)
        }
    }

    
    func didPanNewSticker(sender: UIPanGestureRecognizer) {
        var location = sender.locationInView(view)
        
        if (sender.state == UIGestureRecognizerState.Began) {
            newStickerView.transform = CGAffineTransformMakeScale(1.2, 1.2)
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            sender.view!.center = location
            newStickerView.transform = CGAffineTransformMakeScale(1.2, 1.2)
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            newStickerView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @IBAction func didTapBackground(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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

}
