//
//  GoogleDrive.swift
//  csulb beach hacks project
//
//  Created by Roland Gill on 4/15/16.
//  Copyright © 2016 Roland Gill. All rights reserved.
//

import Foundation
import GoogleSignIn
import GoogleAPIClientForREST

class GoogleDrive {
    var defaults = UserDefaults.standard
    let gdService: GTLRDriveService
    var viewCtrlr: UIViewController?
    // upload file
    
    init(gdService: GTLRDriveService) {
        self.gdService = gdService
    }
    
    func newFile(folderID: String?, title: String, data: Data, mimeType: String) {
        let file = GTLRDrive_File()
        file.name = title
        if let folder = folderID {
            file.parents = [folder]
        }
        let uploadParameters = GTLRUploadParameters(data: data, mimeType: mimeType)
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParameters)
        
        gdService.uploadProgressBlock = { _, totalBytesUploaded, totalBytesExpectedToUpload in
            print(totalBytesUploaded / totalBytesExpectedToUpload)
        }

        gdService.executeQuery(query) { (response, result, error) in
            guard error == nil else {
                self.uploadAlert(title: "Upload failed:", message: "\(error!.localizedDescription)", viewCtrlr: self.viewCtrlr!)
                // fatalError(error!.localizedDescription)
                return
            }
            self.uploadAlert(title: "Upload successful", message: "Document posted to Google Drive 👍🏼", viewCtrlr: self.viewCtrlr!)
        }
    }

    // MARK: get list of files by name or mimeType
    func get(fileName: String = "", mimeType: String = "", parentId: String?, onComplete: @escaping ([Any]?, Error?) -> ()) {
        var folderList = [GTLRDrive_File]()
        // set up query
        let query = GTLRDriveQuery_FilesList.query()
        
        if let parentID = parentId {
            query.q = "'\(parentID)' in parents"
        } else {
            query.q = "mimeType='\(mimeType)' and name contains '\(fileName)'"
        }
        gdService.executeQuery(query) { (ticket, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let fList = response as? GTLRDrive_FileList {
                folderList = fList.files!
                let strList: [GDFile] = folderList.map({GDFile(fileName: $0.name!, fileId: $0.identifier!, mimeType: $0.mimeType!)})
                // print(strList)
                onComplete(strList, error)
            } else {
                onComplete(nil, error)
            }
        }
    }
    
    // MARK: get single file with contents
    func getFile(fileID: String, mimeType:String, onComplete: @escaping (GTLRDataObject?, Error?) -> ()) {
        let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: fileID)
        gdService.executeQuery(query) { (ticket, file, error) in
            onComplete(file as? GTLRDataObject, error)
        }
    }

    // MARK: get (export) a Google Doc
    func export(fileID: String, mimeType: String, onComplete: @escaping (GTLRDataObject?, Error?) -> ()) {
        let query = GTLRDriveQuery_FilesExport.queryForMedia(withFileId: fileID, mimeType: mimeType)
        gdService.executeQuery(query) { (ticket, file, error) in
            onComplete(file as? GTLRDataObject, error)
        }
    }
    
    func uploadAlert(title: String, message: String, viewCtrlr: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        viewCtrlr.present(alert, animated: true, completion: nil)
        
    }
    
    func createFolder(_ name: String, onCompleted: @escaping (Any?, Error?) -> ()) {
        let file = GTLRDrive_File()
        file.name = name
        file.mimeType = MimeType.folder.rawValue//"application/vnd.google-apps.folder"
        
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: nil)
        query.fields = "id"
        
        gdService.executeQuery(query) { (ticket, folder, error) in
            onCompleted((folder as? GTLRDrive_File)?.identifier, error)
        }
    }
    
}

enum MimeType: String {
    case folder = "application/vnd.google-apps.folder"
    case googleDoc = "application/vnd.google-apps.document"
    // Export only supports Google Docs.
    case pdf = "application/pdf"
    case sheet = "application/vnd.google-apps.spreadsheet"
}

struct GDFile {
    let fileName: String
    let fileId: String
    let mimeType: String
}
