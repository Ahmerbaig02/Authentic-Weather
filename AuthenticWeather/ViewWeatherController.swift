//
//  ViewWeatherController.swift
//  AuthenticWeather
//
//  Created by Mahnoor Fatima on 3/18/18.
//  Copyright © 2018 Mahnoor Fatima. All rights reserved.
//

import UIKit

class ViewWeatherController: UIViewController {

    @IBOutlet var weatherImgView: UIImageView!
    @IBOutlet var temperatureLbl: UILabel!
    @IBOutlet var weatherLbl: UILabel!
    @IBOutlet var LoaderImgView: UIImageView!
    var locationStr:String!
    
    var weatherDict:[String:String] = ["Rainy":"It's Fucking Raining",
        "Stormy":"Fucking Thunder Storms",
        "Sunny":"Let's get Fucking Fried",
        "Cloudy":"Fucking Clouds Everywhere",
        "Mostly Cloudy":"Fucking Clouds Everywhere",
        "Hot":"It's so Fucking Hot",
        "Cold":"It's Fucking Cold",
        "Dry":"Give me some Fucking Water",
        "Wet":"Not to fucking bad today",
        "Windy":"Breezy. Fucking Breezy",
        "Hurricanes":"The Hurricane is coming - may the force be with you",
        "Sand-storms":"The storm is coming - may the force be with you",
        "Snow-storms":"The storm is coming - may the force be with you",
        "Humid":"Not to fucking bad today",
        "Foggy":"Fucking can't see anything",
        "Snow":"Numb fucking fingers. Can't feel my fucking fingers any more",
        "Thundersnow":"t's Ducking Freezing (oh damnit, you fucking autocorrect)",
        "Hail":"It's Fucking Hailing Today",
        "blizzard":"Fucking, My ass is Freezing",
        "Mist":"It's Fucking Eye Blind Mist"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherLbl.text = locationStr
        getWeatherInfoFromWeb()
    }
    
    func getWeatherInfoFromWeb() {
        LoaderImgView.loadGif(name: "Weather")
        
        let yahooWebURL:String = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22\(locationStr!)%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
        
        URLSession.shared.dataTask(with: URL(string: yahooWebURL)!) { (data, response, error) in
            // dispatch from background thread
            DispatchQueue.main.async {
                self.LoaderImgView.image = nil
                UIView.animate(withDuration: 0.5, animations: {
                    self.LoaderImgView.alpha = 0
                })
                if let err = error {
                    //error case
                    print(err.localizedDescription)
                    self.weatherLbl.text = err.localizedDescription
                }
                else {
                    //no error case
                    print(data!)  //data recieved is in the form of bytes
                    
                    // convert byte Data to JSON ([String:Any])
                    do {
                        let jsonObj = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        let jsonDict: [String:Any] = jsonObj as! [String:Any]
                        print(jsonDict) //original json data
                        let model:WeatherModel = WeatherModel(data: jsonDict)
                        if model.error == nil {
                            if (self.weatherDict.index(forKey: model.Text) == nil){
                                self.weatherDict[model.Text] = "It's Fucking "+model.Text
                            }
                            self.weatherImgView.image = #imageLiteral(resourceName: "Cloud")
                            self.weatherLbl.text = self.weatherDict[model.Text]!.replacingOccurrences(of: " ", with: "\n")
                            self.temperatureLbl.text = model.Temp+"º F"
                        } else{
                            self.weatherLbl.text = model.error
                        }
                  
                        
                    } catch {
                        self.weatherLbl.text = "No Weather Data..."
                    }
                    
                }
            }
            
        }.resume()
        
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("deinitialized view weather")
    }

}
