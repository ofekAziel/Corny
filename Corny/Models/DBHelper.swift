//
//  DBHelper.swift
//  Corny
//
//  Created by ofek aziel on 18/08/2020.
//  Copyright © 2020 ofek aziel. All rights reserved.
//

import Foundation
import SQLite3

class DBHelper {
    
    static let instance = DBHelper()
    var db: OpaquePointer?
    var path: String = "Corny.sqlite"
    
    init() {
        self.db = createDB()
        MovieDB.createMovieTable(database: db)
    }
    
    func createDB () -> OpaquePointer? {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(path)
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            return nil
        } else {
            return db
        }
    }
}
