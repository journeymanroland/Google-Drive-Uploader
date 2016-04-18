//
//  GoogleDrive.swift
//  csulb beach hacks project
//
//  Created by Roland Gill on 4/15/16.
//  Copyright © 2016 Roland Gill. All rights reserved.
//

import Foundation
import AeroGearHttp
import AeroGearOAuth2


class GoogleDrive {
    private let API_KEY = "AIzaSyB_AU3yNes270-XurqQDomz7HidNEJuXv0"
    private let BASE_URL = "https://www.googleapis.com/auth/drive"
    private let GET_PATH = "https://www.googleapis.com/drive/v3/files"
    private let UPLOAD_PATH = "https://www.googleapis.com/upload/drive/v3/files"
    var http: Http!
    var fileNames = [AnyObject]()
    
    func newFile(title: String, contents: String) {
        let data = contents.dataUsingEncoding(NSUTF8StringEncoding)
        
        let multiPartData = MultiPartData(data: data!, name: "text", filename: title, mimeType: "text/html")
        let multiPartArray = ["file": multiPartData]
        
        http.request(.POST, path: UPLOAD_PATH, parameters: multiPartArray, completionHandler: { (response, error) in
            if (error != nil) {
                print("Error posting file: \(error)")
            } else {
                print("upload successful, \(response)")
            }
        })
    }
    
    func postDoc(title: String, contents: String) {
        let data = contents.dataUsingEncoding(NSUTF8StringEncoding)
        
        let multiPartData = MultiPartData(data: data!, name: "text", filename: title, mimeType: "text/html")
        let multiPartArray = ["file": multiPartData]
        
        http.request(.POST, path: UPLOAD_PATH, parameters: multiPartArray, completionHandler: { (response, error) in
            if (error != nil) {
                print("Error posting file: \(error)")
            } else {
                print("upload successful, \(response)")
            }
        })
    }
    
    func postImage(image: NSData) {
        let multiPartData = MultiPartData(data: image, name: "image", filename: "new", mimeType: "image/png")
        let multiPartArray =  ["file" : multiPartData]
        self.http.request(.POST, path: UPLOAD_PATH, parameters: multiPartArray, completionHandler: { (response, error) in
            if error != nil {
                print("Error uploading image \(error)")
            } else {
                print("noice! \(response)")
            }
        })
    }
    
    func googleSignIn()  {
        self.http = Http() // use to perform http requests
        
        let testConfig = GoogleConfig(clientId: "284685562281-41nlugn9enua9f79emfsbo6d5up6gghp.apps.googleusercontent.com", scopes: [BASE_URL])
        
        let googModule = OAuth2Module(config: testConfig)
        http.authzModule = googModule
        
        http.request(.GET, path: GET_PATH, parameters: ["orderBy" :"recency desc"], completionHandler: { (response, error) in
            if (error != nil) {
                print("ERROR: \(error)")
            } else {
                print("YAASSSS: \(response)")
                // serialize JSON
                if let resp = response,  // unwrap response
                    let jsonDict = resp as? [String: AnyObject] {
                    //print(jsonDict)
                    dispatch_async(dispatch_get_main_queue(), {
                        let files = jsonDict["files"] as! NSArray
                        for file in files {
                            //print(file["name"]!)
                            self.fileNames.append(file["name"]!!) // get list of IDs
                        }
                        //print(self.fileNames)
                    })
                }
            }
        })
        
    }

}