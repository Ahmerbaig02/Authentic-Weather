//
//  ViewWeatherController.swift
//  AuthenticWeather
//
//  Created by Mahnoor Fatima on 3/18/18.
//  Copyright © 2018 Mahnoor Fatima. All rights reserved.
//

import UIKit

class ViewWeatherController: UIViewController {

    @IBOutlet var weatherLbl: UILabel!
    @IBOutlet var LoaderImgView: UIImageView!
    var locationStr:String!
    
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
                            self.weatherLbl.text = "Temperature: \(model.Temp!)ºF \nText: \(model.Text!)"
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

}
