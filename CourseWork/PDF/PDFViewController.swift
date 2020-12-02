//
//  PDFViewController.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 28.11.20.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {
    
    @IBOutlet weak var pdfView: PDFView!
    var documentData: Data?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = documentData {
            pdfView.document = PDFDocument(data: data)
            pdfView.autoScales = true
            
        }

    }
    
    @IBAction func share(_ sender: Any) {
        if let data = documentData {
            let vc = UIActivityViewController(activityItems: [data], applicationActivities: [])
            present(vc, animated: true, completion: nil)
            
        }
    }

}
