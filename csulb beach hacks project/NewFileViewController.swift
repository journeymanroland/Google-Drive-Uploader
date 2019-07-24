//
//  NewFileViewController.swift
//  csulb beach hacks project
//
//  Created by Roland Gill on 7/9/19.
//  Copyright © 2019 Roland Gill. All rights reserved.
//

import UIKit

class NewFileViewController: UIViewController {
    var docTextView: UITextView?
    
    enum LayoutType {
        case document, spreadSheet, presentation, photo
    }
    var docTypeChosen: LayoutType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let docType = docTypeChosen {
            switch docType {
            default:
                configureDocLayout()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func configureDocLayout() {
//        let docTextDimensions = CGRect(x: 0, y: view.frame.height * 0.85, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        let docTextView = UITextView(frame: view.frame)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
