//
//  APIManager.swift
//  TestProject
//
//  Created by Saavaj on 24/12/18.
//  Copyright © 2018 Saavaj. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class APIManager {
    
    static let shared: APIManager = {
        
        let instance = APIManager()
        return instance
        
    }()

    func searchByDateWith(tag: String, page: Int, complition:@escaping([HitsDataList]?, Bool?, String?,Int?)->()) {
        
        let searchByDate = URLS.searchByTagAPI + "tags=\(tag)&page=\(page)"
        
        Alamofire.request(searchByDate, method: .get, parameters: nil, headers: nil).responseJSON { (response) in
            
            switch response.result {
                
            case .success:
                print(response.result.value as? [String:Any] ?? "No result")
                var arrayHitsObject:[HitsDataList] = []
                var numberOfPage:Int = 0
                if let result = response.result.value as? [String:Any] {
                    
                    if let arrayHits = result["hits"] as? [[String:Any]] {
                        
                        for object in arrayHits {
                            
                            let objHit = HitsDataList(dictionary: object)
                            arrayHitsObject.append(objHit)
                        }
                        
                    }
                    if let number = result["nbPages"] as? Int {
                        numberOfPage = number
                    }
                }
               
                
                complition(arrayHitsObject, true, nil,numberOfPage)
                
            case .failure(let error) :
                print(error)
                complition([],false, error.localizedDescription,0)
                
            }
        }
    }
}
