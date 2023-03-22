//
//  NewsSesssion.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 08/03/2023.
//

import Foundation
import Alamofire

class NewsSession {
    func session(url: URLConvertible, callback: @escaping ( Result<Data, AFError>) -> Void) {
        AF.request(url).responseData { data in
            callback(data.result)
        }
        
    }
}
