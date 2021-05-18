//
//  DetailsText.swift
//  Carrots
//
//  Created by Benjamin Breton on 28/04/2021.
//

import SwiftUI
struct DetailsText: View {
    let title: String
    let texts: [String: (text: String, order: Int)]
    private var keys: [String] {
        var allKeys = texts.keys.map({ "\($0.description)" })
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
