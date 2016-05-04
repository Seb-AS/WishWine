//
//  WineDBClient.swift
//  WishWine
//
//  Created by Sebas on 5/2/16.
//  Copyright © 2016 Sebas. All rights reserved.
//

import Foundation

class WineDBClient {
    
    // singleton instance stored as static constant
    static let sharedInstance = WineDBClient()
    
    let session = NSURLSession.sharedSession()
    
    typealias CompletionHandler = (result: AnyObject!, error: NSError?) -> Void
    
    // MARK: - All purpose task method for data
    
    func taskForResource(resource: String, parameters: [String : AnyObject], completionHandler: CompletionHandler) -> NSURLSessionDataTask {
        //make the input mutable
        var mutableParameters = parameters
        
        // Add in the breweryDB API Key
        mutableParameters["akey"] = Constants.ApiKey
        
        let urlString = Constants.BaseUrl + WineDBClient.escapedParameters(mutableParameters)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            if let error = downloadError {
                completionHandler(result: nil, error: error)
            } else {
                WineDBClient.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
            }
        }
        
        task.resume()
        
        return task
    }
    
    func wineGlassSearch(searchString: String, completionHandler: (result: [WineGlass]?, error: NSError?) -> Void) -> NSURLSessionDataTask? {
        
        let parameters = [Keys.Query: searchString, Keys.NResults: "100", Keys.Category: "wine"]
        let resource = Resources.Search
        
        let task = taskForResource(resource, parameters: parameters) { JSONResult, error in
            
            if let error = error {
                completionHandler(result: nil, error: error)
                
            } else {
                
                if let winedata = JSONResult.valueForKey("wines") as? [[String : AnyObject]] {
                    
                    var wineList = [WineGlass]()
                    
                    for wine in winedata {
                        
                        var varietal = wine["varietal"] as? String ?? "n/a"
                        var snoothrank = wine["snoothrank"] as? String ?? "n/a"
                        let wineName = wine["name"] as! String
                        var winery = wine["winery"] as? String ?? "n/a"
                        var imageURL = wine["image"] as? String ?? "http://clipartsign.com/upload/2016/02/22/wine-bottle-black-clipart-image-the-clipart.png"
                        
                        if varietal == "" {
                            varietal = "n/a"
                        }
                        if snoothrank == "" {
                            snoothrank = "n/a"
                        }
                        if winery == "" {
                            winery = "n/a"
                        }
                        if imageURL == "" {
                           imageURL = "http://clipartsign.com/upload/2016/02/22/wine-bottle-black-clipart-image-the-clipart.png"
                        }
                        
                        wineList.append(WineGlass(varietal: varietal, snoothrank: snoothrank, wineName: wineName, winery: winery, imageURL: imageURL))
                    }
                    completionHandler(result: wineList, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "wineGlassSearch parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse wineGlassSearch"]))
                }
            }
        }
        
        return task
    }
    
    // Parsing the JSON
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: CompletionHandler) {
        
        do {
            let parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            
            completionHandler(result: parsedResult, error: nil)
            
        } catch let error as NSError {
            
            completionHandler(result: nil, error: error)
        }
    }
    
    // URL Encoding a dictionary into a parameter string
    
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            // make sure that it is a string value
            let stringValue = "\(value)"
            
            // Escape it
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            // Append it
            if let unwrappedEscapedValue = escapedValue {
                urlVars += [key + "=" + "\(unwrappedEscapedValue)"]
            } else {
                print("Warning: trouble escaping string \"\(stringValue)\"")
            }
        }
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
}