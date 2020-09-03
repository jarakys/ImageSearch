//
//  SearchItem.swift
//  ImageSearch
//
//  Created by Kirill on 02.09.2020.
//  Copyright © 2020 Samax. All rights reserved.
//

import Foundation
import RealmSwift

class FoundedItem: Object {
    @objc dynamic var searchedText: String = ""
    @objc dynamic var image: Data = Data()
}
