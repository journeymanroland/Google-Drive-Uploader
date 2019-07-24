//
//  GoogleDriveFoldersTableCtrlr.swift
//  csulb beach hacks project
//
//  Created by Roland Gill on 4/3/16.
//  Copyright © 2016 Roland Gill. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST

class GoogleDriveFoldersTableCtrlr: UITableViewController {
    
    var allFolders = [GDFile]()
    var folderContents = [GDFile]()
    var gd: GoogleDrive?
    var selectedFolderName = ""
    @IBOutlet weak var newFileButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        // (0.0, 0.0, 414.0, 896.0)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "All Folders"
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFolders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "file", for: indexPath)
        cell.textLabel?.text = allFolders[indexPath.row].fileName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedObject = allFolders[indexPath.row]
        //let selectedCell = tableView.dequeueReusableCell(withIdentifier: "file", for: indexPath)
        if selectedObject.mimeType == "application/vnd.google-apps.folder" {
            // folder selected
            gd?.get(mimeType: selectedObject.mimeType, parentId: selectedObject.fileId, onComplete: { (response, error) in
                guard error == nil else {
                    print(error.debugDescription)
                    return
                }
                // print(response!)
                
                self.folderContents = (response as? [GDFile])!
                self.performSegue(withIdentifier: "folderSelected", sender: self)
            })
        } else { // file selected
            gd?.getFile(fileID: selectedObject.fileId, mimeType: selectedObject.mimeType, onComplete: { (response, error) in
                guard error == nil else {
                    print(error.debugDescription)
                    return
                }
                print(response)
                self.selectedFolderName = selectedObject.fileName
                self.performSegue(withIdentifier: "fileSelected", sender: self)
            })
        }
        tableView.dequeueReusableCell(withIdentifier: "file")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "folderSelected", let selectedFolderVC = segue.destination as? SelectedFolderTableViewController {
            print("segue success")
            selectedFolderVC.gd = gd
            selectedFolderVC.navigationItem.title = selectedFolderName
            selectedFolderVC.folderContents = folderContents
        } else if segue.identifier == "fileSelected", let selectedFileVC = segue.destination as? SelectedFileViewController {
            
        }
    }
}

