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
    let gd = GoogleDrive()
    var fileNames = [AnyObject]()
    
    @IBOutlet weak var newDocTitle: UITextField!
    @IBOutlet weak var newDocContents: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gd.googleSignIn()
        
    }
    
    @IBAction func postToDrive(sender: UIBarButtonItem) {
        if let title = newDocTitle.text,
            let contents = newDocContents.text {
            gd.newFile(title, contents: contents)
        }
        
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
            gd.postImage(data)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}

