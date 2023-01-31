//
//  RealmMigrator.swift
//  GifyAssignment
//
//  Created by macbook on 28/01/23.
//

import Foundation
import RealmSwift

enum RealmMigrator {
    static private func migrationBlock(migration: Migration, oldSchemaVersion: UInt64) {
        // do stuffs for migration
    }
    
    static func setDefaultConfiguration() {
        let config = Realm.Configuration(
            schemaVersion: 1, // current migration, mention the migration changes on bumping the version up
            migrationBlock: migrationBlock)
        Realm.Configuration.defaultConfiguration = config
    }
}
