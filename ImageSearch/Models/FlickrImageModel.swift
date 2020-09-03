//
//  FlickrImageModel.swift
//  ImageSearch
//
//  Created by Kirill on 02.09.2020.
//  Copyright © 2020 Samax. All rights reserved.
//

import Foundation

struct FlickrImageModel: ImageDownloadable {
    let id: String
    let secret: String
    let server: String
    let farm: Int
    var apiProvider: APIProvider
}

extension FlickrImageModel {
    init?(json: [String: Any]) {
        guard
            let photos = json["photos"] as? [String: Any] else {
            return nil
        }
        
        guard let photoArr = photos["photo"] as? [[String:Any]], let photo = photoArr.first  else { return nil }
        
        guard let id = photo["id"] as? String else { return nil }
        guard let secret = photo["secret"] as? String else { return nil }
        guard let server = photo["server"] as? String else { return nil }
        guard let farm = photo["farm"] as? Int else { return nil }

        self.init(id: id, secret: secret, server: server, farm: farm, apiProvider: APIProvider.flickr(APIAction.loadImage(farm, server, id, secret)))
    }
}
