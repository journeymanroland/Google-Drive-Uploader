//
//  FileUploadViewController.swift
//  csulb beach hacks project
//
//  Created by Roland Gill on 7/3/19.
//  Copyright © 2019 Roland Gill. All rights reserved.
//

import UIKit

class FileUploadViewController: UIViewController {
    
    @IBOutlet weak var docTypePicker: UIPickerView!
    
    let fileOptions = ["Document", "Photo", "Presentation", "Spreadsheet"]
    
    var gd: GoogleDrive?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "New Upload"
        docTypePicker.delegate = self
        docTypePicker.dataSource = self
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 
    
        @IBAction func postToDrive(_ sender: UIBarButtonItem) {
//            if let file = newDocContents.text,
//                let data = file.data(using: .utf8) {
//                let firstLine = file.firstIndex(of: "\n") ?? file.endIndex
//                let title = file[..<firstLine]
//                gd!.newFile(folderID: nil, title: String(title), data: data, mimeType: "text/html")
//            }
        }
    
        @IBAction func takePicture(sender: UIBarButtonItem) {
            let imgPicker = UIImagePickerController()
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
//                imgPicker.delegate = self
//                imgPicker.allowsEditing = false
//                imgPicker.sourceType = .camera
//                imgPicker.cameraCaptureMode = .photo
//                imgPicker.modalPresentationStyle = .fullScreen
//                self.present(imgPicker, animated: true, completion: nil)
            } else {
                print("foo")
            }
        }
    
    //    @IBAction func pickImgFromCameraRoll(sender: UIBarButtonItem) {
    //        let imgPicker = UIImagePickerController()
    //        imgPicker.delegate = self
    //        imgPicker.sourceType = .photoLibrary
    //        self.present(imgPicker, animated: true, completion: nil)
    //    }

}

extension FileUploadViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fileOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fileOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(fileOptions[row])
    }
}
