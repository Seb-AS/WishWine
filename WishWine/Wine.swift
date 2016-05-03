//
//  Wine.swift
//  WishWine
//
//  Created by Sebas on 5/2/16.
//  Copyright © 2016 Sebas. All rights reserved.
//

import Foundation
import CoreData

class Wine: NSManagedObject {
    
    struct Keys {
        static let Varietal = "varietal"
        static let WineryID = "wineryId"
        static let WineName = "wineName"
        static let Winery = "winery"
        static let Image = "image"
    }   
    
    /*
     name: "Ermitage le Pavillon Chapoutier Northern Rhone",
     code: "ermitage-le-pavillon-chapoutier-northern-rhone-2005-1",
     region: "France > Rhône > Northern Rhône",
     winery: "M. Chapoutier",
     winery_id: "m-chapoutier",
     varietal: "Syrah",
     price: "264.00",
     vintage: "2005",
     type: "Red Wine",
     link: "http://www.snooth.com/wine/ermitage-le-pavillon-chapoutier-northern-rhone-2005-1/",
     tags: "",
     image: "http://ei.isnooth.com/multimedia/b/7/9/image_1610077_square.jpeg",
     snoothrank: "n/a",
     available: 0,
     num_merchants: 0,
     num_reviews: 4
     */
    
    @NSManaged var varietal: String
    @NSManaged var wineryId: String
    @NSManaged var wineName: String
    @NSManaged var winery: String
    @NSManaged var image: String
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Wine", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
    }
    init(dict: [String: AnyObject], context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Wine", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        varietal = dict[Keys.Varietal] as! String
        wineryId = dict[Keys.WineryID] as! String
        wineName = dict[Keys.WineName] as! String
        winery = dict[Keys.Winery] as! String
        image = dict[Keys.Image] as! String
    }
}