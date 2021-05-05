//
//  AppList.swift
//  Carrots
//
//  Created by Benjamin Breton on 02/04/2021.
//

import SwiftUI
import CoreData
struct AppList<T: NSManagedObject>: View {
    let items: [T]
    let placeHolder: String
    let title: String?
    let commonPot: Pot?
    let withDivider: Bool
    @EnvironmentObject var gameDoor: GameDoor
    init(_ items: [T], placeHolder: String, commonPot: Pot? = nil, title: String? = nil, withDivider: Bool = true) {
        self.items = items
        self.placeHolder = placeHolder
        self.commonPot = commonPot
        self.title = title
        self.withDivider = withDivider
    }
    var body: some View {
        VStack {
            if withDivider { Divider() }
            ScrollView {
                if items.count > 0 {
                    if let commonPot = commonPot {
                        PotCell(pot: commonPot)
                            .withNavigationLink(destination: PotAddings(pot: commonPot))
                    }
                    if let title = title {
                        Text(title)
                            .withTitleFont()
                    }
                }
                SimpleList(items: items, placeHolder: placeHolder)
                    .environmentObject(gameDoor)
            }
            if withDivider { Divider() }
        }
    }
}
fileprivate struct SimpleList<T: NSManagedObject>: View {
    let items: [T]
    let placeHolder: String
    @EnvironmentObject var gameDoor: GameDoor
    private var isPlaceHolderVisible: Bool { items.count == 0 }
    var body: some View {
        Group {
            ForEach(items, id: \.description) { item in
                if let athletic = item as? Athletic {
                    AthleticCell(athletic: athletic)
                        .environmentObject(gameDoor)
                        .contextMenu {
                            Text("Delete")
                                .inDeleteButton {
                                    gameDoor.delete(athletic)
                                }
                        }
                } else if let pot = item as? Pot {
                    PotCell(pot: pot)
                        .environmentObject(gameDoor)
                } else if let sport = item as? Sport {
                    SportCell(sport: sport)
                        .environmentObject(gameDoor)
                } else if let performance = item as? Performance {
                    PerformanceCell(performance: performance)
                        .environmentObject(gameDoor)
                }
            }
            if isPlaceHolderVisible {
                Text(placeHolder)
                    .withSimpleFont()
                    .inRectangle(.topLeading)
                    .transition(.slide)
            }
        }
    }
}
