//
//  CommentDB.swift
//  Corny
//
//  Created by ofek aziel on 20/08/2020.
//  Copyright © 2020 ofek aziel. All rights reserved.
//

import Foundation
import SQLite3

class CommentDB {
    
    static func creatUserTable(database: OpaquePointer?) {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS USERS (ID TEXT PRIMARY KEY, FIRST_NAME TEXT, LAST_NAME TEXT, IS_ADMIN INTEGER, USER_UID TEXT)", nil, nil, &errormsg)
        if(res != 0){
            print("error creating table");
            return
        }
    }
}
