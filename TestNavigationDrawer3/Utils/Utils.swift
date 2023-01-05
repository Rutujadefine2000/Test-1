//
//  Utils.swift
//  TestNavigationDrawer3
//
//  Created by Brahmastra on 20/12/22.
//  Copyright © 2022 Brahmastra. All rights reserved.
//


import Foundation
import UIKit
import Alamofire
import ARSLineProgress

final class Utils : NSObject {
    
    static let sharedInstance = Utils()
    let loginDetails = UserDefaults();
      let api = "https://www.tanpool.com/carpooladmin/api/"
    
       let failureResp = ["status": "false", "message": "Response error occured"]
     let timedOutResp = ["status": "false", "message": "The request timed out"]
    
    
    func getAllMatches(completion : @escaping ([String : Any]) -> () ) {
        let header = ["Content-type": "application/json"]
        
        Alamofire.request("https://api.foursquare.com/v2/venues/search?ll=40.7484,-73.9857&oauth_token=NPKYZ3WZ1VYMNAZ2FLX1WLECAWSMUVOQZOIDBN53F3LVZBPQ&v=20180616", method: .get, encoding: JSONEncoding.default,
                          headers: header).responseJSON {
                            response in
                            switch response.result {
                            case .success:
                                print(response.result);
                                if let data = response.result.value as? [String : Any]{
                                    completion(data)
                                }
                                break
                            case.failure(let error):
                                print(error)
                                print(response)
                                completion(self.failureResp)
                            }
        }
    }
}
