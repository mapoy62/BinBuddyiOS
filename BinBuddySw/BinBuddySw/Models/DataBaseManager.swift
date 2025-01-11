//
//  DataBaseManager.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 11/01/25.
//

import Foundation
import SQLite3

class DatabaseManager {
    static let shared = DatabaseManager() // Singleton

    private var db: OpaquePointer?

    private init() {
        openDatabase()
        createTable()
    }

    // Abrir o crear la base de datos
    private func openDatabase() {
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("TipsDatabase.sqlite")
        print("Database path: \(filePath)")

        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            print("Error al abrir la base de datos.")
        } else {
            print("Base de datos abierta correctamente.")
        }
    }

    // Crear la tabla
    private func createTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS Tips (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tip TEXT NOT NULL
        );
        """

        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, createTableQuery, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Tabla creada exitosamente.")
            } else {
                print("No se pudo crear la tabla.")
            }
        } else {
            print("Error al preparar la consulta de creación de la tabla.")
        }
        sqlite3_finalize(createTableStatement)
    }

    // Cerrar la base de datos
    deinit {
        sqlite3_close(db)
    }
}

extension DatabaseManager {
    func insertTip(_ tip: String) {
        let insertQuery = "INSERT INTO Tips (tip) VALUES (?);"
        var insertStatement: OpaquePointer?

        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (tip as NSString).utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Tip guardado exitosamente.")
            } else {
                print("Error al guardar el tip.")
            }
        } else {
            print("Error al preparar la consulta de inserción.")
        }

        sqlite3_finalize(insertStatement)
    }
}

extension DatabaseManager {
    func fetchTips() -> [String] {
        let fetchQuery = "SELECT tip FROM Tips;"
        var fetchStatement: OpaquePointer?
        var tips: [String] = []

        if sqlite3_prepare_v2(db, fetchQuery, -1, &fetchStatement, nil) == SQLITE_OK {
            while sqlite3_step(fetchStatement) == SQLITE_ROW {
                if let tipCStr = sqlite3_column_text(fetchStatement, 0) {
                    let tip = String(cString: tipCStr)
                    tips.append(tip)
                }
            }
        } else {
            print("Error al preparar la consulta de selección.")
        }

        sqlite3_finalize(fetchStatement)
        return tips
    }
}

