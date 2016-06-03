//
//  ViewController.swift
//  SwiftFlickerSearcher2
//
//  Created by suraj poudel on 30/05/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import UIKit
import Foundation

class ViewController:UIViewController{
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var searchBar:UISearchBar!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    
    private var flickr = Flickr()
    private var searches = [FlickrSearchResults]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Search", style: .Plain, target: nil, action: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let selectedIndexPath = tableView.indexPathForSelectedRow{
            tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
        }
    }
}
extension ViewController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searches.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let searchResult = searches[indexPath.row]
        cell.textLabel?.text  = searchResult.searchString
        cell.detailTextLabel?.text = "(\(searchResult.flickrPhotos.count))"
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationViewController = segue.destinationViewController
            as? SearchResultsViewController{
            if let indexPath = tableView.indexPathsForSelectedRows?.first{
                destinationViewController.searchResults = self.searches[indexPath.row]
            }
        }
    }
}

extension ViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        searchBar.hidden = true
        activityIndicator.startAnimating()
        flickr.search(searchBar.text!) { (results, error) in
            self.searchBar.hidden = false
            self.activityIndicator.stopAnimating()
            if let error = error{
                let alert = UIAlertController(title: "Flickr Error", message: error.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            if let results = results{
                let index = self.searches.indexOf({$0.searchString == searchBar.text!})
                if let index = index{
                    self.searches.removeAtIndex(index)
                    self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow:index,inSection:0)], withRowAnimation: .Fade)
                }
                self.searches.append(results)
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow:self.searches.count-1,inSection:0)], withRowAnimation: .Fade)
            }
            
        }
        
        
    }
}