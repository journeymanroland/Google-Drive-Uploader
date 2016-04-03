//
//  ViewController.swift
//  csulb beach hacks project
//
//  Created by Roland Gill on 4/2/16.
//  Copyright © 2016 Roland Gill. All rights reserved.
//

import UIKit
import AeroGearHttp
import AeroGearOAuth2
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var http: Http!
    private let API_KEY = "AIzaSyB_AU3yNes270-XurqQDomz7HidNEJuXv0"
    private let BASE_URL = "https://www.googleapis.com/auth/drive"
    private let GET_PATH = "https://www.googleapis.com/drive/v3/files"
    private let UPLOAD_PATH = "https://www.googleapis.com/upload/drive/v3/files"
    var fileNames = [AnyObject]()
    
    @IBOutlet weak var newDocTitle: UITextField!
    @IBOutlet weak var newDocContents: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.http = Http() // use to perform http requests
        
        let testConfig = GoogleConfig(clientId: "284685562281-41nlugn9enua9f79emfsbo6d5up6gghp.apps.googleusercontent.com", scopes: [BASE_URL])
        
        let googModule = OAuth2Module(config: testConfig)
        http.authzModule = googModule
        newDocTitle.text = "smoke ring for my halo"
//        self.http.POST("https://www.googleapis.com/upload/drive/v2/files", parameters:  self.extractImageAsMultipartParams(),
//                       completionHandler: {(response, error) in
//                        if (error != nil) {
//                            self.presentAlert("Error", message: error!.localizedDescription)
//                        } else {
//                            self.presentAlert("Success", message: "Successfully uploaded!")
//                        }
//        })
        
        http.request(.GET, path: GET_PATH, parameters: ["orderBy" :"recency desc"], completionHandler: { (response, error) in
            if (error != nil) {
                print("ERROR: \(error)")
            } else {
               //print("YAASSSS: \(response)")
               // serialize JSON
                // unwrap response
                // optional dwncast as dictionary
                if let resp = response,
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
    
    @IBAction func postToDrive(sender: UIBarButtonItem) {
        if let title = newDocTitle.text,
            let contents = newDocContents.text {
            
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
        //
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "show recent files" {
            if let tblCtrlr = segue.destinationViewController as? RecentFilesTableCtrlr {
                tblCtrlr.recentFiles = self.fileNames
            }
        }
    }
    
    
    @IBAction func takePicture(sender: AnyObject) {
        let imgPicker = UIImagePickerController()
        //if imgPicker.isSourceTypeAvailable {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imgPicker.allowsEditing = false
            imgPicker.sourceType = .Camera
            imgPicker.cameraCaptureMode = .Photo
            imgPicker.modalPresentationStyle = .FullScreen
            presentViewController(imgPicker, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func pickImgFromCameraRoll(sender: UIBarButtonItem) {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.sourceType = .PhotoLibrary
        self.presentViewController(imgPicker, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let chosenImg: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage,
        let data = UIImagePNGRepresentation(chosenImg) {
            let multiPartData = MultiPartData(data: data, name: "image", filename: "new", mimeType: "image/png")
            let multiPartArray =  ["file" : multiPartData]
            self.http.request(.POST, path: UPLOAD_PATH, parameters: multiPartArray, completionHandler: { (response, error) in
                if error != nil {
                    print("Error uploading image \(error)")
                } else {
                    print("noice! \(response)")
                }
            })
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
}

