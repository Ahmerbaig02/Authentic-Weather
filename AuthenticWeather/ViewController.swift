//
//  ViewController.swift
//  AuthenticWeather
//
//  Created by Mahnoor Fatima on 3/18/18.
//  Copyright © 2018 Mahnoor Fatima. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet var WeatherBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.WeatherBtn.layer.cornerRadius = 10
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller:ViewWeatherController = segue.destination as! ViewWeatherController
        let location = locationTF.text!
        controller.locationStr = location
        
    }
    
    @IBAction func getWeatherBtnAction(_ sender: Any) {
        self.performSegue(withIdentifier: "ViewWeatherSegue", sender: nil )
    }
    
    
    deinit {
        print("deinitialized");
    }
}

