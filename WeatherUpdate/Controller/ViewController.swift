//
//  ViewController.swift
//  WeatherUpdate
//
//  Created by Shahtaj Khalid on 2/23/18.
//  Copyright © 2018 Shahtaj Khalid. All rights reserved.
//

import UIKit
import SVGKit

class ViewController: UIViewController {

    // View Outlets
    @IBOutlet weak var TemperatureLabel: UILabel!
    @IBOutlet weak var BlueSVGImage: UIImageView!
    @IBOutlet weak var GreenSVGImage: UIImageView!
    @IBOutlet weak var RedSvgImage: UIImageView!
    
    // Model Class's Object
    let WeatherUpdates = ServiceCalls()
    
    // Constants
    let defaults = UserDefaults.standard
    let RedImage = SVGKImage(named: "RedCircle.svg")
    let GreenImage = SVGKImage(named: "GreenCircle")
    let BlueImage = SVGKImage(named: "BlueCircle.svg")
    let openweatherApiURL = "http://api.openweathermap.org/data/2.5/weather?q=Karachi,PK&units=metric&appid=14f66a2297ee4fc4e8e28d677c94dc31"
  
    override func viewDidLoad() {
        super.viewDidLoad()
       
         // Loading SVGMedia Files into imageViews
        LoadSvgsintoImageViews()
        
        
        
        // Fetching today's Temperature
        
        WeatherUpdates.GetKhiWeather(["":""], url: (openweatherApiURL)) { (succeeded: Bool, msg: String) -> () in
            
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                // If no temperature is returened due to any error, it will load previously loaded temperature, else will show the current onne.
                // And if an error occur when the applications is build for the first time and there is no previous tempertute, it will display the message to re-check later
                
                let Temperature =  self.defaults.object(forKey: "KhiTempinCelsius") as? Int ?? 000
                if Temperature != 000 {
                    
                    self.TemperatureLabel.text = "\(String(Temperature))C"
                    
                }else{
                    
                    self.TemperatureLabel.text = "Please Re-Check Later"
                }
            })
        }
        
       
    }
    
    func LoadSvgsintoImageViews(){
       
        RedSvgImage.image = RedImage?.uiImage
        GreenSVGImage.image = GreenImage?.uiImage
        BlueSVGImage.image = BlueImage?.uiImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

