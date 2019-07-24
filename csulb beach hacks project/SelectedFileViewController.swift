//
//  SelectedFileViewController.swift
//  csulb beach hacks project
//
//  Created by Roland Gill on 7/3/19.
//  Copyright © 2019 Roland Gill. All rights reserved.
//

import UIKit
import PDFKit

class SelectedFileViewController: UIViewController {
    
    var pdfView = PDFView()
    var pdfData: Data?
    var backButton = UIButton(type: .system)
    override func viewDidLoad() {
        super.viewDidLoad()
        // manually set up view
        print(view.frame.height)
        configureLayout()
        // Do any additional setup after loading the view.
        if let pdf = pdfData,
            let doc = PDFDocument(data: pdf) {
            pdfView.document = doc
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+9) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        pdfView.frame = CGRect(x: 0, y: view.frame.height * 0.15, width: view.frame.width, height: view.frame.height * 0.85)
        backButton.frame = CGRect(x: 0, y: 10, width: 20, height: 10)
    }
    
    func configureLayout() {
        view.backgroundColor = UIColor.yellow
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(UIColor.blue, for: .normal)
        view.addSubview(backButton)
        // view.addSubview(pdfView)
        backButton.addTarget(self, action: Selector("goToPreviousVC:"), for: .touchUpInside)
    }
    func goToPreviousVC() {
        self.dismiss(animated: true, completion: nil)
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
