//
//  SelectedFolderTableViewController.swift
//  csulb beach hacks project
//
//  Created by Roland Gill on 7/3/19.
//  Copyright © 2019 Roland Gill. All rights reserved.
//

import UIKit
import PDFKit
import GoogleAPIClientForREST

class SelectedFolderTableViewController: UITableViewController {
    
    var folderContents = [GDFile]()
    var gd: GoogleDrive?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0 // Array(Set(folderContents.map({$0.mimeType}))).count
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return folderContents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fileInFolder", for: indexPath)
        cell.textLabel?.text = folderContents[indexPath.row].fileName
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = folderContents[indexPath.row]
        let selectedFileVC = SelectedFileViewController()
        switch selectedItem.mimeType {
        case "application/pdf": // PDF
            gd?.getFile(fileID: selectedItem.fileId, mimeType: selectedItem.mimeType, onComplete: { (response, error) in
                self.setupFileViewer(error: error, response: response)
            })
        case "application/vnd.google-apps.spreadsheet", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "application/vnd.openxmlformats-officedocument.presentationml.presentation", "image/png", "text/plain", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "text/html", "application/vnd.google-apps.document": // google doc
            gd?.export(fileID: selectedItem.fileId, mimeType: "application/pdf", onComplete: { (response, error) in
                self.setupFileViewer(error: error, response: response)
            })
        default:
            print("unsupported file type: \(selectedItem.mimeType)")
        }
    }
    
    func setupFileViewer(error: Error?, response: GTLRDataObject?) {
        guard error == nil else {
            print(error!.localizedDescription)
            return
        }
        print(response)
        //                print(response?.data)
        let selectedFileVC = SelectedFileViewController()
        selectedFileVC.pdfData = response?.data
        self.present(selectedFileVC, animated: true, completion: nil)
    }
    //@objc
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
