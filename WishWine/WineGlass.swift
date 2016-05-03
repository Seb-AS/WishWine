//
//  WineGlass.swift
//  WishWine
//
//  Created by Sebas on 5/2/16.
//  Copyright © 2016 Sebas. All rights reserved.
//

import Foundation

struct WineGlass {
    var varietal: String
    var winery: String
    var wineryId: String
    var wineName: String
    var image: String
    
    init(varietal: String, wineryId: String, wineName: String, winery: String, imageURL: String) {
        self.varietal = varietal
        self.wineryId = wineryId
        self.wineName = wineName
        self.winery = winery
        self.image = imageURL
    }
}