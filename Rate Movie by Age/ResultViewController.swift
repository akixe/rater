//
//  ResultViewController.swift
//  Rate Movie by Age
//
//  Created by Akixe on 07/11/2018.
//  Copyright © 2018 Akixe. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ResultViewController: UIViewController {

    let API_KEY = "8867ce94f6bff8d531397e2e16066efc"
    
    
    var searchText : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doSearchRequest(with: searchText)
        
    }
    
    func doSearchRequest(with query: String) {
        let requestURL = "https://api.themoviedb.org/3/search/movie"
        let parameters: [String:String] = ["query":query, "api_key": API_KEY]
        
        Alamofire.request(requestURL, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                
                
                let responseJSON : JSON = JSON(response.result.value!)
                print(responseJSON)
                if responseJSON["success"].exists() && responseJSON["success"].boolValue == false {
                    print("Error")
                    print("\(responseJSON["status_message"].stringValue)")
                    return
                }
                if responseJSON["results"].exists() && responseJSON["results"].arrayValue.count == 0 {
                    print("Error")
                    print("Not found")
                    return
                }
                print("OK! We got the movie data")
                let movieId = responseJSON["results"].arrayValue[0]["id"].stringValue
                self.doCertificationRequest(with: movieId)
                

            }
            else {
                print("Error \(response.result.description)")
                
            }
        }
    }
    
    func doCertificationRequest(with movieId:String) {
        let requestURL = "https://api.themoviedb.org/3/movie/\(movieId)/release_dates"
        let parameters: [String:String] = ["api_key": API_KEY]
        let order = ["ES", "US", "PT", "FR", "IT","GB", "CA", "AU", "DE", "GR", "NZ", "IN", "NL", "BR", "FI", "BG", "MY", "CA-QC", "SE", "DK", "NO", "HU", "LT", "RU", "PH"]
        Alamofire.request(requestURL, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                
                
                let responseJSON : JSON = JSON(response.result.value!)
                print(responseJSON)
                if responseJSON["success"].exists() && responseJSON["success"].boolValue == false {
                    print("Error")
                    print("\(responseJSON["status_message"].stringValue)")
                    return
                }
                if responseJSON["results"].exists() && responseJSON["results"].arrayValue.count == 0 {
                    print("Error")
                    print("Not found")
                    return
                }
                print("OK! We got the movie certifications")
                
                let results = responseJSON["results"].arrayValue
                
                let certifications: [Certification] = results
                    .sorted(by: {
                        let code0 = $0["iso_3166_1"].stringValue
                        let code1 = $1["iso_3166_1"].stringValue
                        return order.firstIndex(of: code0) ?? 0 < order.firstIndex(of: code1) ?? 0
                    })
                    .map({ (result) in
                        // todo crear objeto certification y rellenar con lo que tengo
                        // -- code
                        // -- certiiaction
                        /*var res = result["release_dates"].arrayValue
                        res[0]["code"].stringValue = result["iso_3166_1"].stringValue*/
                        let certification : Certification = Certification(
                            countryCode: result["iso_3166_1"].stringValue,
                            certificationCode: result["release_dates"].arrayValue[0]["certification"].stringValue)
                        return certification
                    })
                
                
                    /*.flatMap({return $0})
                    .map({ (release) in
                        return release["certification"].stringValue
                    })
                    .filter({$0 != "" })*/
                for cert in certifications {
                        print(cert)
                }
                
                
                
            }
            else {
                print("Error \(response.result.description)")
                
            }
        }
    }
    


}


public class Certification {
    
    private let countryCode: String;
    private let certificationCode: String;
    
    init(countryCode: String, certificationCode: String){
        self.countryCode = countryCode
        self.certificationCode = certificationCode
    }
    
    
}

extension Certification: CustomStringConvertible {
    public var description: String {
        return "(\(countryCode), \(certificationCode))"
    }
}
