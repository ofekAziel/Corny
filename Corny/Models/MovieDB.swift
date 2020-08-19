//
//  MovieDB.swift
//  Corny
//
//  Created by ofek aziel on 18/08/2020.
//  Copyright © 2020 ofek aziel. All rights reserved.
//

import Foundation
import SQLite3

class MovieDB {
    
    static func createMovieTable(database: OpaquePointer?) {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS MOVIES (ID TEXT PRIMARY KEY, NAME TEXT, ACTORS TEXT, DESCRIPTION TEXT, DIRECTOR TEXT, GENRE TEXT, IMAGE_URL TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    static func addOrUpdateMovieToDb(movie: Movie, database: OpaquePointer?) {
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database, "INSERT OR REPLACE INTO MOVIES (ID, NAME, ACTORS, DESCRIPTION, DIRECTOR, GENRE, IMAGE_URL) VALUES (?,?,?,?,?,?,?);", -1, &sqlite3_stmt,nil) == SQLITE_OK) {
            let id = movie.id.cString(using: .utf8)
            let name = movie.name.cString(using: .utf8)
            let actors = movie.actors.cString(using: .utf8)
            let description = movie.description.cString(using: .utf8)
            let director = movie.director.cString(using: .utf8)
            let genre = movie.genre.cString(using: .utf8)
            let imageUrl = movie.imageUrl.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, id, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 2, name, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 3, actors, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 4, description, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 5, director, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 6, genre, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 7, imageUrl, -1, nil);
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func deleteMovieFromDb(movieId: String, databse: OpaquePointer?) {
            let deleteStatementString = "DELETE FROM MOVIES WHERE id = ?;"

            var deleteStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(databse, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
                
                sqlite3_bind_text(deleteStatement, 1, movieId, -1, nil)

                if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    print("Successfully deleted row.")
                } else {
                    print("Could not delete row.")
                }
            } else {
                print("DELETE statement could not be prepared")
            }

            sqlite3_finalize(deleteStatement)
            print("deleted movie")
    }
    
    static func getAllMoviesFromDb(database: OpaquePointer?) -> [Movie] {
        var sqlite3_stmt: OpaquePointer? = nil
        var data: [Movie] = []

        if (sqlite3_prepare_v2(database, "SELECT * from MOVIES;", -1, &sqlite3_stmt, nil)
            == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW) {
                let id = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let name = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                let actors = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                let description = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                let director = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)
                let genre = String(cString:sqlite3_column_text(sqlite3_stmt,5)!)
                let imageUrl = String(cString:sqlite3_column_text(sqlite3_stmt,6)!)
                let movie = Movie(id: id, name: name, genre: genre, actors: actors, director: director, description: description, imageUrl: imageUrl)
                data.append(movie)
            }
        }
        
        sqlite3_finalize(sqlite3_stmt)
        return data
    }
}
