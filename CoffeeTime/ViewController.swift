//
//  ViewController.swift
//  CoffeeTime
//
//  Created by Nick Miceli on 8/15/23.
//

import UIKit
import Lottie

class ViewController: UIViewController {

    var prevStatus = "READY"
    
    @IBOutlet weak var animView: LottieAnimationView!
    @IBOutlet weak var statusTxt: UITextView!
    @IBOutlet weak var brew: UIButton!
    @IBOutlet weak var reset: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        brew.layer.cornerRadius = 20
        brew.layer.masksToBounds = true
        reset.layer.cornerRadius = 20
        reset.layer.masksToBounds = true
        reset.isHidden = true;
        statusTxt.isEditable = false;
        
        animView.contentMode = .scaleAspectFit
        animView.loopMode = .loop
        animView.animationSpeed = 0.8
        animView.play()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureSheet()
    }

    
    @IBAction func brewButtonPressed(_ sender: Any) {
        brew.isEnabled = false;
        makeRestCall(brew: 1)
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        reset.isEnabled = false;
        makeRestCall(brew:0)
    }
    
    func makeRestCall(brew : Int) {
        var urlStr:String;
        
        if(brew == 0){
            urlStr = "http://192.168.0.11/brew/0"
        } else if (brew == 1){
            urlStr = "http://192.168.0.11/brew/1"
        } else{
            urlStr = "http://192.168.0.11"
        }
        
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data{
                    do {
                        let res = try JSONDecoder().decode(Response.self, from: data)
                        DispatchQueue.main.async {
                            // Display the status returned by the coffeemaker
                            self.displayStatus(status: res.machineStatus)
                            
                            // If the status is heating or brewing call again
                            if (res.machineStatus == "HEATING" || res.machineStatus == "BREWING"){
                                DispatchQueue.main.asyncAfter(deadline:.now() + 1.0){
                                    self.makeRestCall(brew:-1)
                                }
                            }
                        }
                    }catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    func displayStatus(status:String){
        switch status {
            case "READY":
            if(prevStatus == "READY"){
                break
            }
            statusTxt.text = "Ready to brew"
            brew.isHidden = false
            brew.isEnabled = true
            reset.isHidden = true
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
            brew.isHidden = true
            reset.isHidden = true
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
            brew.isHidden = true
            reset.isHidden = true
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
            reset.isHidden = false
            reset.isEnabled = true
            brew.isHidden = true
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
            reset.isHidden = false
            reset.isEnabled = true
            brew.isHidden = true
            animView.pause()
            animView.animation = LottieAnimation.named("Watering Loader")
            animView.play()
            prevStatus = "ADD_WATER"
            break
            case "NO_MUG":
            if(prevStatus == "NO_MUG"){
                break
            }
            statusTxt.text = "No mug..."
            reset.isHidden = false
            reset.isEnabled = true
            brew.isHidden = true
            animView.pause()
            animView.animation = LottieAnimation.named("Coffee Mug 2")
            animView.play()
            prevStatus = "NO_MUG"
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
                0.12 * context.maximumDetentValue
            }), .custom(identifier: .large, resolver: { context in
                0.40 * context.maximumDetentValue
            })]
            sheet.largestUndimmedDetentIdentifier = .large
            
            
        }
        self.present(vc, animated: false)
    }
    
}

struct Response:Codable{
    let time:String
    let machineStatus:String
}

