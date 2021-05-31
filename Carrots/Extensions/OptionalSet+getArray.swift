//
//  OptionalSet+getArray.swift
//  Carrots
//
//  Created by Benjamin Breton on 31/05/2021.
//

import Foundation
extension Optional where Wrapped: NSSet {
    func getArray<Type>() -> [Type] {
        guard let set = self, let array = set.allObjects as? [Type] else { return [] }
        return array
    }
}
