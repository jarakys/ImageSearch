//
//  NetworkService.swift
//  ImageSearch
//
//  Created by Kirill on 02.09.2020.
//  Copyright © 2020 Samax. All rights reserved.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    private let session = URLSession(configuration: .default)
    
    func sendRequest(requestModel: RequestModel, completion: @escaping(Result<Data, Error>) -> Void) {
        print(requestModel.urlRequest())
        let task = session.dataTask(with: requestModel.urlRequest()) {(data, response, error) in
            var result: Result<Data, Error>
            if let error = error {
                result = .failure(error)
            } else if let data = data {
                result = .success(data)
            } else {
                result = .failure(APIError.noData)
            }
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()
    }
    
    func cancelWithUrlRequest(requestModel: RequestModel) {
        session.getAllTasks { tasks in
            tasks
                .filter { $0.state == .running }
                .filter { $0.originalRequest == requestModel.urlRequest() }.first?
                .cancel()
        }
    }
}
