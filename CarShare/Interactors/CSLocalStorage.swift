//
//  CSLocalStorage.swift
//  CarShare
//
//  Created by nicholas on 3/21/23.
//

import UIKit

class CSLocalStorage: NSObject {
    
    static func documentDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    static func save(data: Data, with fileName: String, to path: URL) {
        do {
            try data.write(to: path.appendingPathComponent(fileName), options: .atomic)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static func remove(fileName: String, at path: URL) {
        try? FileManager.default.removeItem(at: path.appendingPathComponent(fileName))
    }
    
    static func loadPDF(for fileName: String, from path: URL) -> URL {
        let documentDirUrl = documentDirectory()
        return documentDirUrl.appendingPathComponent(fileName)
    }
}
