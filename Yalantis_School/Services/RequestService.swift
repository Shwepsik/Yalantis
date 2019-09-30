//
//  RequestService.swift
//  Yalantis_School
//
//  Created by Valerii on 9/29/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation
import Alamofire

typealias JSON = [String: AnyObject]
typealias ResponseBlock = (_ result: Any?, _ error: Error?)
    -> Void
typealias AnswerResponse = (_ result: String?, _ error: Error?) -> Void
typealias Response = (_ result: Any?) -> Void

protocol NetwordDataProvider {
    func tryLoadInfo(method: HTTPMethod,
                     params: Parameters?,
                     headers: HTTPHeaders?,
                     path: String,
                     responseBlock: @escaping ResponseBlock)
}

class RequestService: NetwordDataProvider {
    let baseUrl: String = "https://8ball.delegator.com/magic/JSON/"

    func tryLoadInfo(method: HTTPMethod,
                     params: Parameters?,
                     headers: HTTPHeaders?,
                     path: String,
                     responseBlock: @escaping ResponseBlock) {

        let fullPath: String = baseUrl + path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        if let url: URL = URL(string: fullPath) {
            request(url, method: method, parameters: params, headers: headers).validate()
                .responseJSON { (responseJSON) in
                    switch responseJSON.result {
                    case .success:
                        guard let jsonArray = responseJSON.result.value as? JSON else {
                            return
                        }
                        responseBlock(jsonArray, nil)
                    case .failure(let error):
                        responseBlock(nil, error)
                }
            }
        }
    }
}
