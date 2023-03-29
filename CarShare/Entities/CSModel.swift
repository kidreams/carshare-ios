//
//  CSModel.swift
//  CarShare
//
//  Created by nicholas on 3/21/23.
//

import Foundation
import SwiftyJSON

protocol CSModel {
    init?(json: JSON)
}

extension JSON {
    
    func csModelArray<T: CSModel>() -> [T] {
        guard let array = array else { return [T]() }
        return array.compactMap {
            T(json: $0)
        }
    }
    
    func csModelArray<T: CSModel>(action: ((T) -> T)?) -> [T] {
        guard let array = array else { return [T]() }
        guard let _ = action else { return csModelArray() }
        let mappedArray = array.compactMap { (json) -> T? in
            guard let item = T(json: json) else { return nil }
            if let editedItem = action?(item) { return editedItem }
            else { return item }
        }
        return mappedArray
    }
    
    // Convert JSON to any CSModel
    func csModel<T: CSModel>() -> T? {
        return T(json: self)
    }
}

