//
//  ViewController.swift
//  CoffeeTime
//
//  Created by Nick Miceli on 8/15/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var brew: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        brew.layer.cornerRadius = 20
        brew.layer.masksToBounds = true
    }


    @IBAction func brewButton(_ sender: Any) {
    }
    
}

