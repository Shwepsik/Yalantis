//
//  DataFetcher.swift
//  Yalantis_School
//
//  Created by Valerii on 9/29/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation
import Alamofire

protocol DataFetch {
    func tryLoadAnswer(_ path: String, _ responseBlock: @escaping (AnswerResponse))
}

class DataFetcher: DataFetch {

    let requestService: RequestService

    init(requestService: RequestService) {
        self.requestService = requestService
    }

    func tryLoadAnswer(_ question: String, _ responseBlock: @escaping (AnswerResponse)) {
        requestService.tryLoadInfo(method: .get, params: nil, headers: nil, path: question) { (response, error) in
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

   private func jsonToNSData(json: Any) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: json,
                                              options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
}
