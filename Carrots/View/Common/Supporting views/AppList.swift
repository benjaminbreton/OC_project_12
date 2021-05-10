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
            if let athletics = items as? [Athletic] {
                AthleticsList(athletics: athletics)
                    .environmentObject(gameDoor)
            }
            if let pots = items as? [Pot] {
                PotsList(pots: pots)
                    .environmentObject(gameDoor)
            }
            if let sports = items as? [Sport] {
                SportsList(sports: sports)
                    .environmentObject(gameDoor)
            }
            if let performances = items as? [Performance] {
                PerformancesList(performances: performances)
                    .environmentObject(gameDoor)
            }
            if isPlaceHolderVisible {
                Text(placeHolder)
                    .withSimpleFont()
                    .inRectangle(.topLeading)
                    .withCellAnimation()
            }
        }
    }
}

fileprivate struct AthleticsList: View {
    let athletics: [Athletic]
    @EnvironmentObject var gameDoor: GameDoor
    var body: some View {
        VStack {
            ForEach(athletics, id: \.description) { athletic in
                if !athletic.willBeDeleted {
                    AthleticCell(athletic: athletic)
                        .environmentObject(gameDoor)
//                        .canBeDeleted {
//                            gameDoor.delete(athletic)
//                        }
                        
                }
            }
        }
    }
}

fileprivate struct PotsList: View {
    let pots: [Pot]
    @EnvironmentObject var gameDoor: GameDoor
    
    var body: some View {
        Group {
            ForEach(pots, id: \.description) { pot in
                PotCell(pot: pot)
                    .environmentObject(gameDoor)
            }
        }
    }
}

fileprivate struct SportsList: View {
    let sports: [Sport]
    //@State var isItemHidden: [Pot: Bool]
    @EnvironmentObject var gameDoor: GameDoor
    
    var body: some View {
        Group {
            ForEach(sports, id: \.description) { sport in
                SportCell(sport: sport)
                    .environmentObject(gameDoor)
                    .canBeDeleted {
                        gameDoor.delete(sport)
                    }
            }
        }
    }
}

fileprivate struct PerformancesList: View {
    let performances: [Performance]
    @EnvironmentObject var gameDoor: GameDoor
//    let athleticOwner: Athletic?
//    let sportOwner: Sport?
    
    var body: some View {
        Group {
            ForEach(performances, id: \.description) { performance in
                PerformanceCell(performance: performance)
                    .environmentObject(gameDoor)
                    .canBeDeleted {
                        gameDoor.delete(performance)
                    }
            }
        }
    }
}

// MARK: - View modifiers

fileprivate struct WithCellAnimation: ViewModifier {
    func body(content: Content) -> some View {
        content
            .animation(.linear)
            .transition(.move(edge: .trailing))
    }
}

fileprivate struct CanBeDeleted: ViewModifier {
    let deleteAction: () -> Void
    func body(content: Content) -> some View {
        content
            .contextMenu {
                Text("Delete")
                    .inDeleteButton(action: deleteAction)
            }
            .withCellAnimation()
    }
}

// MARK: - View Extension



extension View {
    func withCellAnimation() -> some View {
        modifier(WithCellAnimation())
    }
    fileprivate func canBeDeleted(deleteAction: @escaping () -> Void) -> some View {
        modifier(CanBeDeleted(deleteAction: deleteAction))
    }
    
}
