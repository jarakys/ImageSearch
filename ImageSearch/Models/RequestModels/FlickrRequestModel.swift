//
//  FlickrRequestModel.swift
//  ImageSearch
//
//  Created by Kirill on 02.09.2020.
//  Copyright © 2020 Samax. All rights reserved.
//

import Foundation

class FlickrRequestModel: RequestModel {
    
    override var apiProvider: APIProvider {
        return .flickr(action)
    }
    
    override var path: String {
        switch action {
        case .getImage(_):
            return "https://www.flickr.com/services/rest"
        case .loadImage(let farm, let server, let id, let secret):
            return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).png"
        }
    }
    
    override var parameters: [String : String?] {
        switch action {
            case .getImage(let text):
                return [
                    "method": "flickr.photos.search",
                    "api_key": apiProvider.apiKey,
                    "text": text,
                    "per_page": 1.description,
                    "format": "json",
                    "nojsoncallback": "?"
                ]
        case .loadImage(_, _, _, _):
                return [:]
        }
    }
    
    override var cachePolicy: URLRequest.CachePolicy {
        return .returnCacheDataElseLoad
    }
    
    override var timeout: Double {
        return 30
    }
    
}
