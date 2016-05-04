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
    var snoothrank: String
    var wineName: String
    var image: String
    
    init(varietal: String, snoothrank: String, wineName: String, winery: String, imageURL: String) {
        self.varietal = varietal
        self.snoothrank = snoothrank
        self.wineName = wineName
        self.winery = winery
        self.image = imageURL
    }
}