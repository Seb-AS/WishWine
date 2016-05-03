//
//  DetailViewcontroller.swift
//  WishWine
//
//  Created by Sebas on 5/2/16.
//  Copyright © 2016 Sebas. All rights reserved.
//

import UIKit
import ImageLoader
import IJProgressView

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    @IBOutlet weak var wineImageView: UIImageView!
    @IBOutlet weak var wishButton: UIButton!
    
    let sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
    var hideWishButton:Bool = false
    
    var detailObject: AnyObject! {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let detailObject = detailObject {
            if let detailDescriptionLabel = detailDescriptionLabel, wineImageView = wineImageView {
                IJProgressView.shared.showProgressView(view)
                detailDescriptionLabel.text = detailObject.valueForKey("wineName")!.description
                
                wineImageView.load((detailObject.valueForKey("image")?.description)!, placeholder: nil) { URL, image, error, cacheType in
                    print("URL \(URL)")
                    print("error \(error)")
                    print("cacheType \(cacheType.hashValue)")
                    
                    IJProgressView.shared.hideProgressView()
                }
                title = detailObject.valueForKey("varietal")?.description
                
                wishButton.hidden = hideWishButton
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addToWishlist(sender: UIButton) {
        
        // Start by making sure there is a beer to add to the list
        if detailObject == nil {
            displayGenericAlert("Use the search bar to find wines to add to your wishlist.", message: "")
        } else {
            // Build a beer and use the NSManagedObject init method to persist it to the Core Store
            let WineDict = detailObject!
            
            let _ = Wine(dict: WineDict as! [String : AnyObject], context: sharedContext)
            
        }
        
       CoreDataStackManager.sharedInstance().saveContext()
        
        // Reset the instance vars
        //title = ""
        //detailDescriptionLabel.text = ""
        //detailObject = nil
        //wineImageView = nil
        wishButton.hidden = true
        
       let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.switchBackFirst();
        appDelegate.switchBack()
    }
    
    // MARK: - Segues
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addToWishList" {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! WishViewController
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = false
        }
    }*/
}