//
//  ViewController.swift
//  CoffeeTime
//
//  Created by Nick Miceli on 8/15/23.
//

import UIKit

class ViewController: UIViewController {

    var brewing = false
    
    @IBOutlet weak var brew: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        brew.layer.cornerRadius = 20
        brew.layer.masksToBounds = true
    }


    @IBAction func brewButton(_ sender: Any) {
        if(!brewing){
            // TODO change brewing bool once done testing
            brewing = false
            makeRestCall(brew: true);
        }
    }
    
    func makeRestCall(brew : Bool) {
        var urlStr:String;
        
        if(brew){
            urlStr = "http://10.0.0.21/brew/1"
        } else{
            urlStr = "http://10.0.0.21/brew/0"
        }
        
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data{
                    if let jsonString = String(data:data, encoding: .utf8) {
                        print(jsonString)
                    }
                }
            }.resume()
        }
        
        DispatchQueue.main.asyncAfter(deadline:.now() + 1.0){
            self.makeRestCall(brew:true)
        }
        
       
        

    }
    
}

