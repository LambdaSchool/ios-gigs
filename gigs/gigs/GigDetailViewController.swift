//
//  GigDetailViewController.swift
//  gigs
//
//  Created by ronald huston jr on 5/6/20.
//  Copyright © 2020 HenryQuante. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    @IBOutlet weak var gigNameTextField: UITextField!
    @IBOutlet weak var dueDate: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(_ sender: Any) {
        guard let gigName = gigNameTextField.text,
            gigName.isEmpty == false,
            let description = descriptionTextView.text
            else {
                return
        }
        
        //  let gig = 
    }
    

}
