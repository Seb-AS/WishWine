//
//  ViewControllerExtensions.swift
//  WishWine
//
//  Created by Sebas on 5/2/16.
//  Copyright © 2016 Sebas. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func displayErrorAlert(error: NSError, shake: Bool = false) {
        if let errorMessage = error.userInfo["error"] as? String {
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            if shake {
                shakeScreen()
            }
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func displayGenericAlert(title: String, message: String, shake: Bool = false) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        if shake {
            shakeScreen()
        }
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func subscribeToKeyboardNotifications() {
        // register the VC to respond to keyboard visibility change notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIViewController.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIViewController.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        // de-register the VC to respond to keyboard visibility change notifications
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        // if top of field being edited is less than 100 higher from the bottom than the top of keyboard will be,
        //    raise the view to get it there during editing. That gives user at least 100 points of clearance to type
        let hKeys = getKeyboardHeight(notification)
        var yUp = CGFloat(0)
        for v in view.subviews {  // find which field is editing
            if v.isFirstResponder() {
                yUp = view.frame.height - v.frame.minY
            }
        }
        view.frame.origin.y -= max(0, hKeys + 100 - yUp)        
    }
    
    func keyboardWillHide() {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        // get the userInfo dictionary from the notification
        let userInfo = notification.userInfo
        
        // get the keyboard CGRect from the userInfo dictionary
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.CGRectValue().height
    }
    
    /* via http://stackoverflow.com/a/9371196/1415844 */
    func shakeScreen() {
        let anim = CAKeyframeAnimation( keyPath:"transform" )
        anim.values = [
            NSValue( CATransform3D:CATransform3DMakeTranslation(-5, 0, 0 ) ),
            NSValue( CATransform3D:CATransform3DMakeTranslation( 5, 0, 0 ) )
        ]
        anim.autoreverses = true
        anim.repeatCount = 2
        anim.duration = 7/100
        
        view.layer.addAnimation( anim, forKey:nil )
    }
}