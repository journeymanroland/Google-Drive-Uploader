//
//  ViewController.swift
//  csulb beach hacks project
//
//  Created by Roland Gill on 4/2/16.
//  Copyright © 2016 Roland Gill. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher

class ViewController: UIViewController, UINavigationControllerDelegate, GIDSignInUIDelegate {
    var gd: GoogleDrive?
    let gdService = GTLRDriveService()
    var googleUser: GIDGoogleUser?
    var retrievedFiles = [Any]()
    var activityIndicator = UIActivityIndicatorView(style: .gray)
    //let signInMessage = "Signed in to Google Drive."
    
    @IBOutlet weak var signInLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // configure Google Drive
        // gdSignIn()
        self.navigationItem.hidesBackButton = true
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        GTMSessionFetcher.setLoggingEnabled(true)
        let labelAnimation: CATransition = CATransition()
        labelAnimation.duration = 1.0
        labelAnimation.type = .fade
        signInLabel.layer.add(labelAnimation, forKey: "changeTextTransition")
        gdSignIn()
    }
    
    func gdSignIn() {
        if let googleSignIn = GIDSignIn.sharedInstance() {
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance()?.scopes = [kGTLRAuthScopeDrive]
            
            // alert user of sign in
            
            // check if user is already signed in
            if googleSignIn.hasAuthInKeychain() {
                print("\nAlready signed in\n")
                googleSignIn.signInSilently()
            } else {
                GIDSignIn.sharedInstance()?.signIn()
            }
        }
        gd = GoogleDrive(gdService: gdService)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        let defaults = UserDefaults.standard
//        var nUploads = 1
//        if let numCameraUploads = defaults.object(forKey: "Camera upload") as? Int {
//           defaults.set(numCameraUploads + 1, forKey: "Camera upload")
//            nUploads = numCameraUploads
//        }
//        if let chosenImg: UIImage = info[.originalImage] as? UIImage,
//            let data = chosenImg.pngData() {
//            gd!.newFile(title: "Camera upload \(nUploads)", data: data, mimeType: "image/png")
//        }
//        self.dismiss(animated: true, completion: nil)
//        
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gdFoldersTVC = segue.destination as? GoogleDriveFoldersTableCtrlr {
            gdFoldersTVC.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "file")
            gdFoldersTVC.allFolders = retrievedFiles as! [GDFile]
            gdFoldersTVC.gd = self.gd
        }
    }
}

extension ViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            gdService.authorizer = user.authentication.fetcherAuthorizer()
            googleUser = user

            // self.signInLabel.text = signInMessage
            gd?.get(mimeType: "application/vnd.google-apps.folder", parentId: nil, onComplete: {(folders, error) in
               guard error == nil else {
                    print(error.debugDescription)
                    return
                }
                self.signInLabel.text = "Signed in!"
                self.retrievedFiles = folders! as! [GDFile]
                self.performSegue(withIdentifier: "loggedIn", sender: self)
            })
        }
    }
}

extension UITextView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if text.contains("Enter text here...") {
            text = ""
        }
    }
}
