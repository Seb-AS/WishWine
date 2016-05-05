//
//  SearchViewController.swift
//  WishWine
//
//  Created by Sebas on 5/2/16.
//  Copyright © 2016 Sebas. All rights reserved.
//

import UIKit
import IJProgressView

class SearchViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Properties
    var detailViewController: DetailViewController? = nil
    let searchController = UISearchController(searchResultsController: nil)
    var currentWineGlass: WineGlass?  // since searchBar is returning results in this form
    var wineGlassResults = [WineGlass]() // this, rather than a temporary managed object context, is the scratchpad here
    var searchTask: NSURLSessionDataTask?
    let sharedContext = CoreDataStack.sharedInstance().managedObjectContext
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        tableView.tableHeaderView = searchController.searchBar
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return wineGlassResults.count
        }
        return wineGlassResults.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let wine = wineGlassResults[indexPath.row]
        if (indexPath.row % 2 == 0)
        {
            cell.backgroundColor = UIColor.groupTableViewBackgroundColor()
        }
        else
        {
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        cell.textLabel!.text = wine.wineName
        cell.detailTextLabel!.text = wine.winery
        
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    // MARK: - Search Bar Delegate methods:
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        // check internet connection only every two keystrokes to be less annoying during network failure
        if !Reachability.isConnectedToNetwork() && searchText.characters.count % 2 == 1 {
            dispatch_async(dispatch_get_main_queue()) {
               self.displayGenericAlert("Please check your internet connection.", message: "The network is very slow or not connected.")
            }
        }
        // Cancel the last task
        if let task = searchTask {
            task.cancel()
        }
        
        // If the text is empty don't search
        if searchText == "" {
            wineGlassResults = [WineGlass]()
            
            tableView.reloadData()
            
            objc_sync_exit(self) // I see this in Jason's code but not Jarrod's, and not sure why
            return
        }
        // Start a new search task
        
        //show progress
        IJProgressView.shared.showProgressView(view)
        
        searchTask = WineDBClient.sharedInstance.wineGlassSearch(searchText) { wineGlasslist, error in
            
            self.searchTask = nil
            
            if let result = wineGlasslist {
                self.wineGlassResults = result
                
                dispatch_async(dispatch_get_main_queue()) {
                    IJProgressView.shared.hideProgressView()
                    self.tableView.reloadData()
                }
            } else {
                if let error = error {
                    dispatch_async(dispatch_get_main_queue()) {
                        IJProgressView.shared.hideProgressView()
                        
                        if wineGlasslist == nil || wineGlasslist?.count == 0  {
                            self.searchController.searchBar.text = ""
                            self.displayGenericAlert("Sorry", message: "No Resuts")
                        }
                        else {
                            
                            self.displayErrorAlert(error)
                        }
                    }
                }
            }
        }
    }
        
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let wineGlass:WineGlass = wineGlassResults[indexPath.row] as WineGlass
                
                var WineDict = [String: AnyObject]()
                
                WineDict[Wine.Keys.Varietal] = wineGlass.varietal
                WineDict[Wine.Keys.WineName] = wineGlass.wineName
                WineDict[Wine.Keys.Winery] = wineGlass.winery
                WineDict[Wine.Keys.SnoothRank] = wineGlass.snoothrank
                WineDict[Wine.Keys.Image] = wineGlass.image
                
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.detailObject = WineDict
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        _ = searchController.searchBar
    }
}
