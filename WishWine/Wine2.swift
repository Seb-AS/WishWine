//
//  Wine2.swift
//  WishWine
//
//  Created by Sebas on 5/4/16.
//  Copyright © 2016 Sebas. All rights reserved.
//

import Foundation
import CoreData

class Wine2: NSManagedObject {
    
    struct Keys {
        static let Varietal = "varietal"
        static let SnoothRank = "snoothrank"
        static let WineName = "wineName"
        static let Winery = "winery"
        static let Image = "image"
    }
    
    @NSManaged var varietal: String
    @NSManaged var wineName: String
    @NSManaged var winery: String
    @NSManaged var snoothrank: String
    @NSManaged var image: String
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}