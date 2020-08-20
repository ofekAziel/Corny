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
    
    static func creatCommentTable(database: OpaquePointer?) {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS COMMENTS (ID TEXT PRIMARY KEY, COMMENT TEXT, CREATED_AT TEXT, USER_UID TEXT)", nil, nil, &errormsg)
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    static func addOrUpdateCommentToDb(comment: Comment, database: OpaquePointer?) {
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database, "INSERT OR REPLACE INTO COMMENTS (ID, COMMENT, CREATED_AT, USER_UID) VALUES (?,?,?,?);", -1, &sqlite3_stmt,nil) == SQLITE_OK) {
            let id = comment.id.cString(using: .utf8)
            let commentText = comment.comment.cString(using: .utf8)
            let createdAt = comment.createdAt.dateValue().description.cString(using: .utf8)
            let userUid = comment.userId.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, id, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 2, commentText, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 3, createdAt, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 4, userUid, -1, nil);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE) {
                print("new row added succefully")
            }
        }
        
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func deleteCommentFromDb(commentId: String, databse: OpaquePointer?) {
            let deleteStatementString = "DELETE FROM COMMENTS WHERE id = ?;"

            var deleteStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(databse, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
                
                sqlite3_bind_text(deleteStatement, 1, commentId, -1, nil)

                if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    print("Successfully deleted row.")
                } else {
                    print("Could not delete row.")
                }
            } else {
                print("DELETE statement could not be prepared")
            }

            sqlite3_finalize(deleteStatement)
            print("deleted comment")
    }
    
    static func getAllCommentsFromDb(database: OpaquePointer?) -> [Comment] {
        var sqlite3_stmt: OpaquePointer? = nil
        var data: [Comment] = []

        if (sqlite3_prepare_v2(database, "SELECT * from COMMENTS;", -1, &sqlite3_stmt, nil)
            == SQLITE_OK) {
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW) {
                let id = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let commentText = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                let createdAt = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                let userUid = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                
                let comment = Comment(id: id, comment: commentText, createdAt: createdAt, userId: userUid)
                data.append(comment)
            }
        }
        
        sqlite3_finalize(sqlite3_stmt)
        return data
    }
    
    static func deleteAllComments(database: OpaquePointer?) {
        var sqlite3_stmt: OpaquePointer? = nil
        sqlite3_prepare_v2(database, "DELETE from COMMENTS;", -1, &sqlite3_stmt, nil)
        sqlite3_step(sqlite3_stmt)
    }
}
