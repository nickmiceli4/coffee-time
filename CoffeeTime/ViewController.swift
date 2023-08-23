//
//  ViewController.swift
//  CoffeeTime
//
//  Created by Nick Miceli on 8/15/23.
//

import UIKit
import Lottie

class ViewController: UIViewController {

    var brewing = false
    var prevStatus = "READY"
    
    @IBOutlet weak var animView: LottieAnimationView!
    @IBOutlet weak var statusTxt: UITextView!
    @IBOutlet weak var brew: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        brew.layer.cornerRadius = 20
        brew.layer.masksToBounds = true
        statusTxt.isEditable = false;
        
        animView.contentMode = .scaleAspectFit
        animView.loopMode = .loop
        animView.animationSpeed = 0.8
        animView.play()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureSheet()
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
                    do {
                        let res = try JSONDecoder().decode(Response.self, from: data)
                        DispatchQueue.main.async {
                            self.displayStatus(status: res.machineStatus)
                        }
                    }catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
        
        DispatchQueue.main.asyncAfter(deadline:.now() + 1.0){
            self.makeRestCall(brew:true)
        }
        
       
        

    }
    
    func displayStatus(status:String){
        switch status {
            case "READY":
            if(prevStatus == "READY"){
                break
            }
            statusTxt.text = "Ready to brew"
            animView.pause()
            animView.animation = LottieAnimation.named("Coffee Cup Paper")
            animView.play()
            prevStatus = "READY"
            break
            case "HEATING":
            if(prevStatus == "HEATING"){
                break
            }
            statusTxt.text = "Water is heating"
            animView.pause()
            animView.animation = LottieAnimation.named("Flask Heating Experiment")
            animView.play()
            prevStatus = "HEATING"
            break
            case "BREWING":
            if(prevStatus == "BREWING"){
                break
            }
            statusTxt.text = "Brewing..."
            animView.pause()
            animView.animation = LottieAnimation.named("Coffee Maker")
            animView.play()
            prevStatus = "BREWING"
            break
            case "DONE_BREWING":
            if(prevStatus == "DONE_BREWING"){
                break
            }
            statusTxt.text = "Coffee is ready!"
            animView.pause()
            animView.animation = LottieAnimation.named("Coffee Mug")
            animView.play()
            prevStatus = "DONE_BREWING"
            break
            case "ADD_WATER":
            if(prevStatus == "ADD_WATER"){
                break
            }
            statusTxt.text = "Add water"
            animView.pause()
            animView.animation = LottieAnimation.named("Watering Loader")
            animView.play()
            prevStatus = "ADD_WATER"
            break
            default:
            break
        }
    }
    
    func configureSheet() {
        guard let vc = storyboard?.instantiateViewController(identifier: "Sheet") as? SheetViewController else {
            print("failed to get vc from storyboard")
            return
        }
        
        vc.isModalInPresentation = true
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                0.25 * context.maximumDetentValue
            }), .medium()]
            sheet.largestUndimmedDetentIdentifier = .medium
            
            
        }
        self.present(vc, animated: false)
    }
    
}

struct Response:Codable{
    let time:String
    let machineStatus:String
}

