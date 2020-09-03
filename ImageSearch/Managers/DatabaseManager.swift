//
//  DatabaseManager.swift
//  ImageSearch
//
//  Created by Kirill on 02.09.2020.
//  Copyright © 2020 Samax. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private init() { }
    
    private let fetchQueue = DispatchQueue(label: "DatabaseManager", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())

    func loadHistory(completion: @escaping([HistoryModel]) -> Void) {
        fetchQueue.async {
            autoreleasepool {
                guard let realm = try? Realm() else {
                    completion([])
                    return
                }
                let objects = Array(realm.objects(FoundedItem.self).map({item in
                    return HistoryModel(searchedText: item.searchedText, data: item.image)
                }))
                completion(objects)
            }
        }
    }
    
    func saveFoundedItem(image: Data, searchedText: String, completion: @escaping(HistoryModel?) -> Void) {
        DispatchQueue.init(label: "DatabaseManager").async {
            autoreleasepool {
                guard let realm = try? Realm() else {
                    completion(nil)
                    return
                }
                let item = FoundedItem()
                item.image = image
                item.searchedText = searchedText
                do {
                    try realm.write {
                        realm.add(item)
                        try realm.commitWrite()
                    }
                } catch {
                    completion(nil)
                }
                completion(HistoryModel(searchedText: item.searchedText, data: item.image))
            }
        }
    }
}
