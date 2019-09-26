//
//  RequestController.swift
//  Yalantis_School
//
//  Created by Valerii on 8/18/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation
import Alamofire

typealias JSON = [String: AnyObject]
typealias ResponseBlock = (_ result: Any?, _ error: Error?)
    -> Void

class RequestController {
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

    func tryLoadAnswer(_ path: String, _ responseBlock: @escaping (ResponseBlock)) {
        tryLoadInfo(method: .get, params: nil, headers: nil, path: path) { (response, error) in
            if let json = response {
                do {
                    let model = try JSONDecoder().decode(AnswerModel.self, from: self.jsonToNSData(json: json)!)
                    responseBlock(model.answer, error)
                } catch {
                    responseBlock(nil, error)
                }
            } else {
                responseBlock(nil, error)
            }
        }
    }

    func jsonToNSData(json: Any) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: json,
                                              options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
}
