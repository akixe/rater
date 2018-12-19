//
//  SearchViewController.swift
//  Rate Movie by Age
//
//  Created by Akixe on 07/11/2018.
//  Copyright © 2018 Akixe. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResultSegue" {
            let resultVC = segue.destination as! ResultViewController
            resultVC.searchText = searchText.text!
        }
    }

}
