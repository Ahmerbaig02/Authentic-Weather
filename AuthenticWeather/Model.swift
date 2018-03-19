////
//  Model.swift
//  AuthenticWeather
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class WeatherModel {
    
    var Temp:String!
    var Text:String!
    var error:String!
    
    init(data: [String:Any]) {
        let query = data["query"] as! [String:Any]
        if let results = query["results"] as? [String:Any] {
        let channel = results["channel"] as! [String:Any]
        let item = channel["item"] as! [String:Any]
        let condition = item["condition"] as! [String:Any]
        Temp = condition["temp"] as? String ?? ""
        Text = condition["text"] as? String ?? ""
        }
        else {
            error = "invalid location"
        }
    
    
    }
    

}

