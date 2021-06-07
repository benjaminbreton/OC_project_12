//
//  DetailsText.swift
//  Carrots
//
//  Created by Benjamin Breton on 28/04/2021.
//

import SwiftUI
/**
 Display one or sevral texts in a module.
 */
struct DetailsText: View {
    
    // MARK: - Properties
    
    /// Module's title.
    private let title: String
    /// Texts to display. The *key* is a title to display, the *value* contains a tuple in which has to be indicated the text to display and its order in the module beginning by 1.
    private let texts: [String: (text: String, order: Int)]
    /// Texts keys, in the order indicated in the values tuples.
    private var keys: [String] {
        // get keys
        var allKeys = texts.keys.map({ "\($0.description)" })
        // order keys
        var keys: [String] = []
        if allKeys.count > 0 {
            for count in 1...allKeys.count {
                var deletion: [Int] = []
                for index in allKeys.indices {
                    let key = allKeys[index]
                    if texts[key]?.order ?? 0 == count {
                        keys.append(key)
                        deletion.append(index)
                    }
                }
                if deletion.count > 0 {
                    for index in deletion.indices {
                        allKeys.remove(at: deletion[deletion.count - 1 - index])
                    }
                }
            }
        }
        return keys
    }
    
    // MARK: - Init
    
    init(title: String, texts: [String : (text: String, order: Int)]) {
        self.title = title
        self.texts = texts
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            ForEach(keys.indices) { index in
                HStack {
                    Text(keys[index])
                        .withLightSimpleFont()
                    Text(texts[keys[index]]?.text ?? "")
                }
                .inModule(index == 0 ? title : nil)
            }
        }
    }
}
