//
//  HitsDataList.swift
//  TestProject
//
//  Created by Saavaj on 24/12/18.
//  Copyright © 2018 Saavaj. All rights reserved.
//

import UIKit

class HitsDataList: NSObject {

    var strTitle:String!
    var strCreatedAt:String
    var isSelectedCell:Bool = false
    
    init(dictionary: [String: Any]) {
        strTitle = dictionary["title"] as? String ?? ""
        strCreatedAt = dictionary["created_at"] as? String ?? ""
    }
}
