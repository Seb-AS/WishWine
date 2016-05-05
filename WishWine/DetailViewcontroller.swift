//
//  DetailViewcontroller.swift
//  WishWine
//
//  Created by Sebas on 5/2/16.
//  Copyright © 2016 Sebas. All rights reserved.
//

import UIKit
import CoreData
import ImageLoader
import IJProgressView

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    @IBOutlet weak var wineImageView: UIImageView!
    @IBOutlet weak var wishButton: UIButton!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    
    let sharedContext = CoreDataStack.sharedInstance().managedObjectContext
    var hideWishButton:Bool = false
    var newRating: Int?
    
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
                ratingLabel.text = detailObject.valueForKey("snoothrank")!.description == "n/a" ? "none " :  detailObject.valueForKey("snoothrank")!.description
                
                if !hideWishButton {
                    let rated: Int = detailObject.valueForKey("snoothrank")!.description == "n/a" ? 50 : Int(detailObject.valueForKey("snoothrank")!.description)!
                    ratingSlider.setValue(Float(rated), animated: true)
                }
                
                wishButton.hidden = hideWishButton
                ratingSlider.hidden = hideWishButton
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check internet connection only every two keystrokes to be less annoying during network failure
        if !Reachability.isConnectedToNetwork() {
            dispatch_async(dispatch_get_main_queue()) {
                self.displayGenericAlert("Please check your internet connection.", message: "The network is very slow or not connected.")
            }
        }
        else {
            configureView()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func rate(sender: UISlider) {
        // User set the wine rating
        newRating = lroundf(ratingSlider.value)
        
        ratingLabel.text = String(newRating!)
    }
    
    @IBAction func addToWishlist(sender: UIButton) {
        
        // Start by making sure there is a beer to add to the list
        if detailObject == nil {
            displayGenericAlert("Use the search bar to find wines to add to your wishlist.", message: "")
        } else {
            // Build a beer and use the NSManagedObject init method to persist it to the Core Store           
            
           saveInBackground()            
        }
        
        // Reset the instance vars
        //title = ""
        //detailDescriptionLabel.text = ""
        //detailObject = nil
        //wineImageView = nil
        wishButton.hidden = true
    }

    /*
    ///https://pawanpoudel.svbtle.com/fixing-core-data-concurrency-violations
    */
    
    func saveInBackground() {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.saveWishList()
        }
    }
    
    func saveWishList() {
        let coreDataStack = CoreDataStack()
        
        if let newPrivateQueueContext =
            coreDataStack.newPrivateQueueContext()
        {
            let newWine: Wine2 = NSEntityDescription.insertNewObjectForEntityForName("Wine", inManagedObjectContext: newPrivateQueueContext) as! Wine2
            newWine.varietal = detailObject.valueForKey("varietal")!.description
            newWine.wineName = detailObject.valueForKey("wineName")!.description
            newWine.winery = detailObject.valueForKey("winery")!.description
            newWine.snoothrank = ratingLabel.text!
            newWine.image = detailObject.valueForKey("image")!.description
            
            newPrivateQueueContext.performBlock {
                newPrivateQueueContext.saveRecursively()
            }
        }
    }
    
    func goToNextView() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.switchBackFirst()
        appDelegate.switchBack()
    }
    
}
