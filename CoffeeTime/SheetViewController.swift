//
//  SheetViewController.swift
//  CoffeeTime
//
//  Created by Nick Miceli on 8/22/23.
//

import UIKit

class SheetViewController: UIViewController {

    @IBAction func linkedInPress(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.linkedin.com/in/nicholas-miceli-b1b6a0230/")!)
    }
    
    @IBAction func twitterPress(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://twitter.com/nick_miceli18")!)
    }
    
    @IBAction func igPress(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.instagram.com/nick.miceli/?hl=en")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
