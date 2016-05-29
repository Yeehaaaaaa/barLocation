//
//  BarTableViewController.swift
//  barLocation
//
//  Created by Arthur Daurel on 27/05/16.
//  Copyright © 2016 Arthur Daurel. All rights reserved.
//

import Foundation
import UIKit
import FoldingCell
import SwiftyJSON
import MapKit
import Alamofire
import AlamofireImage

class BarTableViewController: UITableViewController {
    
    let kCloseCellHeight: CGFloat = 150 // equal or greater foregroundView height
    let kOpenCellHeight: CGFloat = 325 // equal or greater containerView height
    
    var cellHeights = [CGFloat]()
    var kRowsCount = 0
    
    var filteredBars: [Bars] = []
    var bars = [Bars]()

    let searchController = UISearchController(searchResultsController: nil)

    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getJson()
        createCellHeightsArray()
        initSearchBar()

    }
    
    func initSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredBars = bars.filter { bar in
            return bar.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    func createCellHeightsArray() {
        for _ in 0...kRowsCount {
            cellHeights.append(kCloseCellHeight)
        }

    }
    
    func getJson() {
        
        let path = NSBundle.mainBundle().pathForResource("Pensebete", ofType: "json")
        let jsonData = NSData(contentsOfFile:path!)
        let json = JSON(data: jsonData!)
        let jsonBars = json["bars"]
        
        var id: Int?
        var address: String?
        var name: String?
        var url: String?
        var image_url: String?
        var tags: String?
        var latitude: Double?
        var longitude: Double?
        
        for (_, subJson) in jsonBars {
            
            if let tmp = subJson["id"].int {
                id = tmp
            } else {
                id = 0
            }
            if let tmp = subJson["address"].string {
                address = tmp
            } else {
                address = "Unknown"
            }
            if let tmp = subJson["name"].string {
                name = tmp
            } else {
                name = "Unknown"
            }
            if let tmp = subJson["url"].string {
                url = tmp
            } else {
                url = "Unknown"
            }
            if let tmp = subJson["image_url"].string {
                image_url = tmp
            } else {
                image_url = "Unknown"
            }
            if let tmp = subJson["tags"].string {
                tags = tmp
            } else {
                tags = "Unknown"
            }
            if let tmp = subJson["latitude"].double {
                latitude = tmp
            } else {
                latitude = 0
            }
            if let tmp = subJson["longitude"].double {
                longitude = tmp
            } else {
                longitude = 0
            }
            let bar = Bars(id: id!, address: address!, name: name!, url: url!, image_url: image_url!, tags: tags!, latitude: latitude!, longitude: longitude!)
            bars.append(bar)
        }
        
        kRowsCount = bars.count
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "background")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        imageView.contentMode = .ScaleAspectFill
        tableView.backgroundColor = .lightGrayColor()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = imageView.bounds
        imageView.addSubview(blurView)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredBars.count
        }
        return bars.count
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if cell is FoldingCell {
            let foldingCell = cell as! FoldingCell
            foldingCell.backgroundColor = UIColor.clearColor()
            
            if cellHeights[indexPath.row] == kCloseCellHeight {
                foldingCell.selectedAnimation(false, animated: false, completion:nil)
            } else {
                foldingCell.selectedAnimation(true, animated: false, completion: nil)
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FoldingCell", forIndexPath: indexPath) as! BarTableViewCell
        
        let bar: Bars
        
        if searchController.active && searchController.searchBar.text != "" {
            bar = filteredBars[indexPath.row]
        } else {
            bar = bars[indexPath.row]
        }
        
        let downloadURL = NSURL(string: bar.image_url)!
        cell.barImageView.af_setImageWithURL(downloadURL)
        cell.address.text = bar.address
        cell.barName.text = bar.name
        cell.barTitle.text = bar.name
        cell.barTags.text = bar.tags
        cell.barButton.tag = indexPath.row
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! FoldingCell
        
        var duration = 0.0
        if cellHeights[indexPath.row] == kCloseCellHeight { // open cell
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 1.1
        }
        
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            }, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        if segue!.identifier == "getBar" {
            let svc = segue!.destinationViewController as! MapBarViewController
            
            if searchController.active && searchController.searchBar.text != "" {
                svc.toPassData = filteredBars[(sender?.tag)!]
            } else {
                svc.toPassData = bars[sender!.tag]
            }
        }
    }
}

extension BarTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

