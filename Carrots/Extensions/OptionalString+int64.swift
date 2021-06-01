//
//  OptionalString+int64.swift
//  Carrots
//
//  Created by Benjamin Breton on 01/06/2021.
//

import Foundation
extension Optional where Wrapped == String {
    var int64: Int64 {
        Int64(self ?? "0") ?? 0
    }
}
