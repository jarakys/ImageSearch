//
//  RequestModel.swift
//  ImageSearch
//
//  Created by Kirill on 02.09.2020.
//  Copyright © 2020 Samax. All rights reserved.
//

import Foundation

enum RequestHTTPMethod: String {
    case get = "GET"
    case post = "POST"
}


class RequestModel: NSObject {
    
    var apiProvider: APIProvider {
        return .none
    }
    
    let action: APIAction
    
    init(action: APIAction) {
        self.action = action
    }
    
    var path: String {
        return ""
    }
    var parameters: [String: String?] {
        return [:]
    }
    var headers: [String: String] {
        return [:]
    }
    var method: RequestHTTPMethod {
        return body.isEmpty ? RequestHTTPMethod.get : RequestHTTPMethod.post
    }
    var body: [String: Any?] {
        return [:]
    }
    
    var timeout: Double {
        return 30
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        return .reloadIgnoringLocalAndRemoteCacheData
    }
    
    func urlRequest() -> URLRequest {
        let endpoint: String = path
        
        var urlQueryItems:[URLQueryItem] = []
        
        for parameter in parameters {
            urlQueryItems.append(URLQueryItem(name: parameter.key, value: parameter.value))
        }
        
        var urlComponents = URLComponents(string: endpoint)
        urlComponents?.queryItems = urlQueryItems
        let url = urlComponents?.url ?? URL(string: path)!
        var request: URLRequest = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeout)
        request.httpMethod = method.rawValue
        
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        if method == RequestHTTPMethod.post {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
            } catch let error {
                print("Request body parse error: \(error.localizedDescription)")
            }
        }
        return request
    }
}
