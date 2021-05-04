//
//  AppList.swift
//  Carrots
//
//  Created by Benjamin Breton on 02/04/2021.
//

import SwiftUI
struct AppList<T: CustomStringConvertible>: View {
    let items: [T]
    let placeHolder: String
    let title: String?
    let commonPot: FakePot?
    init(_ items: [T], placeHolder: String, commonPot: FakePot? = nil, title: String? = nil) {
        self.items = items
        self.placeHolder = placeHolder
        self.commonPot = commonPot
        self.title = title
    }
    var body: some View {
        VStack {
            Divider()
            ScrollView {
                if let commonPot = commonPot {
                    PotCell(pot: commonPot)
                        .withNavigationLink(destination: PotAddings(pot: commonPot))
                }
                if let title = title {
                    Text(title)
                        .withTitleFont()
                }
                SimpleList(items: items, placeHolder: placeHolder)
            }
            Divider()
        }
    }
}
fileprivate struct SimpleList<T: CustomStringConvertible>: View {
    let items: [T]
    let placeHolder: String
    var body: some View {
        Group {
            if items.count > 0 {
                ForEach(items, id: \.description) { item in
                    if let pot = item as? FakePot {
                        PotCell(pot: pot)
                            .withNavigationLink(destination: PotAddings(pot: pot))
                    } else if let athletic = item as? FakeAthletic {
                        AthleticCell(athletic: athletic)
                            .withNavigationLink(destination: AthleticDetails(athletic: athletic))
                    } else if let sport = item as? FakeSport {
                        SportCell(sport: sport)
                            .withNavigationLink(destination: SportDetails(sport: sport))
                    } else if let performance = item as? FakePerformance {
                        PerformanceCell(performance: performance)
                    }
                }
            } else {
                Text(placeHolder)
                    .withSimpleFont()
                    .inRectangle(.topLeading)
            }
        }
    }
}
