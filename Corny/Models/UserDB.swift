//
//  UserDB.swift
//  Corny
//
//  Created by ofek aziel on 19/08/2020.
//  Copyright © 2020 ofek aziel. All rights reserved.
//

import Foundation
import SQLite3

class UserDB {
    
    static func creatUserTable(database: OpaquePointer?) {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS USERS (ID TEXT PRIMARY KEY, FIRST_NAME TEXT, LAST_NAME TEXT, IS_ADMIN INTEGER, USER_UID TEXT)", nil, nil, &errormsg)
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    static func addOrUpdateUserToDb(user: User, database: OpaquePointer?) {
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database, "INSERT OR REPLACE INTO USERS (ID, FIRST_NAME, LAST_NAME, IS_ADMIN, USER_UID) VALUES (?,?,?,?,?);", -1, &sqlite3_stmt,nil) == SQLITE_OK) {
            let id = user.id.cString(using: .utf8)
            let firstName = user.firstName.cString(using: .utf8)
            let lastName = user.lastName.cString(using: .utf8)
            let isAdmin = NSNumber(value: user.isAdmin).int32Value
            let userUid = user.userUid.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, id, -1, nil)
            sqlite3_bind_text(sqlite3_stmt, 2, firstName, -1, nil)
            sqlite3_bind_text(sqlite3_stmt, 3, lastName, -1, nil)
            sqlite3_bind_int(sqlite3_stmt, 4, isAdmin)
            sqlite3_bind_text(sqlite3_stmt, 5, userUid, -1, nil)
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE) {
                print("new row added succefully")
            }
        }
        
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func getCurrentUserFromDb(userUid: String, database: OpaquePointer?) -> User? {
        var sqlite3_stmt: OpaquePointer? = nil
        var data: User!

        if (sqlite3_prepare_v2(database, "SELECT * from USERS WHERE USER_UID = ?;", -1, &sqlite3_stmt, nil) == SQLITE_OK) {
            
            sqlite3_bind_text(sqlite3_stmt, 1, userUid, -1, nil)
            
            if (sqlite3_step(sqlite3_stmt) == SQLITE_ROW) {
                let id = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let firstName = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                let lastName = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                let isAdminInt = Int(sqlite3_column_int(sqlite3_stmt, 3))
                let userUid = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)
                let isAdmin = Bool(truncating: isAdminInt as NSNumber)
                data = User(id: id, firstName: firstName, lastName: lastName, isAdmin: isAdmin, userUid: userUid)
            }
        }
        
        sqlite3_finalize(sqlite3_stmt)
        return data
    }
    
    static func deleteAllUsers(database: OpaquePointer?) {
        var sqlite3_stmt: OpaquePointer? = nil
        sqlite3_prepare_v2(database, "DROP TABLE USERS;", -1, &sqlite3_stmt, nil)
        sqlite3_step(sqlite3_stmt)
    }
}
