//
//  DataFetcher.swift
//  Yalantis_School
//
//  Created by Valerii on 9/29/19.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation
import Alamofire

typealias AnswerModelResponseBlock = (_ result: AnswerModel?, _ error: Error?) -> Void

protocol DataFetching {
    func tryLoadAnswer(_ path: String, _ responseBlock: @escaping (AnswerModelResponseBlock))
}

class DataFetcher: DataFetching {
  private let requestService: NetwordDataProvider

    init(requestService: NetwordDataProvider) {
        self.requestService = requestService
    }

    func tryLoadAnswer(_ question: String, _ responseBlock: @escaping (AnswerModelResponseBlock)) {
        requestService.tryLoadInfo(method: .get, params: nil, headers: nil, path: question) { (response, error) in
            if let json = response {
                do {
                    let model = try JSONDecoder().decode(AnswerModel.self, from: self.jsonToNSData(json: json)!)
                    responseBlock(model, error)
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
