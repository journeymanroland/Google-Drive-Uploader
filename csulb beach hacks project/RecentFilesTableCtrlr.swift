//
//  RecentFilesTableCtrlr.swift
//  csulb beach hacks project
//
//  Created by Roland Gill on 4/3/16.
//  Copyright © 2016 Roland Gill. All rights reserved.
//

import UIKit

class RecentFilesTableCtrlr: UITableViewController {
    
    var recentFiles = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentFiles.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "file")
        
        cell.textLabel?.text = recentFiles.map({ "\($0)" } )[indexPath.row]
        
        return cell
    }
}
