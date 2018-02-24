//
//  ServiceCalls.swift
//  WeatherUpdate
//
//  Created by Shahtaj Khalid on 2/23/18.
//  Copyright © 2018 Shahtaj Khalid. All rights reserved.
//

import Foundation

class ServiceCalls {
    
    // To save the Temperature
    let defaults = UserDefaults.standard
    
    
    
    func GetKhiWeather(_ params : Dictionary<String, String>, url : String, postCompleted : @escaping (_ succeeded: Bool, _ msg: String) -> ()) {
        
        
        var request = URLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print(error)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) {data, response, error -> Void in
            
            do {
                
                // return if no data was passed by service due to any service error or network problem
                guard let data = data else {
                    postCompleted(false, "Failure")
                    return
                }

                // Data Parsing
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    
                    // Parsing Temp from the json
                        if let main = jsonResult["main"] as? NSDictionary
                        {
                            if let tempinCelsius = main["temp"] as? Int {
                                
                                // Setting Temperature in defaults
                                self.defaults.set(tempinCelsius, forKey: "KhiTempinCelsius")
                                self.defaults.synchronize()
                                postCompleted(true, "Success")
                            }
                            else{
                                postCompleted(false, "Failure")
                            }
                        }
                        
                    }
                    else
                    {
                        let jsonStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        postCompleted(false, "Server Error !")
                    }
               
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
}
