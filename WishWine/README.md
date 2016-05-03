# WishWine

Project developed for Udacity iOS Developer Nanodegree

Development environment: 
IDE: Xcode 7.3+ 
Language: Swift 2.2

##Summary

This app allows users to search for wines using the Snooth Api,the user can add it's favorite wines to a Wish list. The WishList will be  stored in Core Data.

![wishwine](https://cloud.githubusercontent.com/assets/2106935/14998659/59efbf0c-115b-11e6-97e5-3bfe8c895d6b.gif)

## Usage

To run the example project, clone the repo, and run pod install from the directory first.

## Implementation

The app has three view controller scenes:

SearchViewController - does the search in the Snooth Api, shows the tableView with the results, shows alerts.

DetailViewController - Shows the information from the tableview cell, title, description, varietal and picture.

TabViewController - Controlls the TabBar taps

WishViewController - shows the saved data in Core Data, allows the user to delete wines and shows a detail on tap

## License

Copyright (c) 2016 Sebastian Masseroni

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
