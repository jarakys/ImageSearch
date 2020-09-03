//
//  ImageDownloader.swift
//  ImageSearch
//
//  Created by Kirill on 02.09.2020.
//  Copyright © 2020 Samax. All rights reserved.
//

import Foundation

class ImageDownloader {
    static func loadImage(imageDownloadable: ImageDownloadable, completion: @escaping (Data?, Error?)-> Void) {
        switch imageDownloadable.apiProvider {
        case .flickr(_):
            let flickrImage = imageDownloadable as! FlickrImageModel
            let requestModel = FlickrRequestModel(action: .loadImage(flickrImage.farm, flickrImage.server, flickrImage.id, flickrImage.secret))
            NetworkService.shared.sendRequest(requestModel: requestModel, completion: {response in
                switch response {
                    case .success(let data):
                        completion(data, nil)
                    case .failure(let error):
                        completion(nil, error)
                }
            })
            default: completion(nil,nil)
        }
    }
}
