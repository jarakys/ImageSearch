//
//  APIProvider.swift
//  ImageSearch
//
//  Created by Kirill on 01.09.2020.
//  Copyright © 2020 Samax. All rights reserved.
//

import Foundation

enum APIAction {
    case getImage(String)
    case loadImage(Int, String, String, String)
}

enum APIProvider {
    case flickr(APIAction)
    case none
    
    var apiKey: String {
        switch self {
        case .flickr(_):
            return Constants.flickrKey
        default:
            return ""
        }
    }
    
    var requestString: String {
        switch self {
        case .flickr(let apiAction):
            switch apiAction {
                case .getImage(_):
                    return "https://www.flickr.com/services/rest/"
                case .loadImage(_, _, _, _):
                    return "https://farm"
            }
        default:
            return ""
        }
    }
}

