//
//  AppList.swift
//  Carrots
//
//  Created by Benjamin Breton on 02/04/2021.
//

import SwiftUI
import CoreData

// MARK: - AppList

/**
 A list of applications entities : Athletics, Pots, Performances or Sports.
 */
struct AppList<T: NSManagedObject>: View {
    
    // MARK: - Properties
    
    /// App's viewmodel.
    @EnvironmentObject var game: GameViewModel
    /// Items to display.
    let items: [T]
    /// Text to display if items property is empty.
    let placeHolder: String
    /// List's title.
    let title: String?
    /// Common pot to display in a pots list.
    let commonPot: Pot?
    /// A boolean indicating whether dividers have to be added at the list's top and bottom.
    let withDivider: Bool
    
    let helpText: String?
    
    let source: Athletic?
    
    @State private var showHelp: Bool = false
    
    // MARK: - Init
    
    init(_ items: [T], placeHolder: String, commonPot: Pot? = nil, title: String? = nil, withDivider: Bool = true, helpText: String? = nil, source: Athletic? = nil) {
        self.items = items
        self.placeHolder = placeHolder
        self.commonPot = commonPot
        self.title = title
        self.withDivider = withDivider
        self.helpText = helpText
        self.source = source
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            if withDivider { Divider() }
            if let text = helpText {
                HelpView(text: text, isShown: $showHelp)
            }
            ScrollView(withDivider ? .vertical : []) {
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
                SimpleList(items: items, placeHolder: placeHolder, source: source)
            }
            if withDivider { Divider() }
        }
    }
}

// MARK: - SimpleList

/**
 Elements to display in an AppList.
 */
fileprivate struct SimpleList<T: NSManagedObject>: View {
    
    // MARK: - Properties
    
    /// App's viewmodel.
    @EnvironmentObject var game: GameViewModel
    /// Items to display.
    let items: [T]
    /// Text to display if items property is empty.
    let placeHolder: String
    /// A boolean indicating whether the placeholder has to be displayed or not.
    private var isPlaceHolderVisible: Bool { items.count == 0 }
    
    let source: Athletic?
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if let athletics = items as? [Athletic] {
                AthleticsList(athletics: athletics)
            }
            if let pots = items as? [Pot] {
                PotsList(pots: pots)
            }
            if let sports = items as? [Sport] {
                SportsList(sports: sports)
            }
            if let performances = items as? [Performance] {
                PerformancesList(performances: performances, source: source)
            }
            if isPlaceHolderVisible {
                Text(placeHolder)
                    .withSimpleFont()
                    .inRectangle(.topLeading)
                    .animation(.easeIn)
                    .transition(.opacity)
            }
        }
    }
}

// MARK: - AthleticsList

/**
 List to display if items are of athletic's type.
 */
fileprivate struct AthleticsList: View {
    let athletics: [Athletic]
    @EnvironmentObject var game: GameViewModel
    var body: some View {
        VStack {
            ForEach(athletics, id: \.description) { athletic in
                AthleticCell(athletic: athletic)
                    .canBeDeleted {
                        game.delete(athletic)
                    }
            }
        }
    }
}

// MARK: - PotsList

/**
 List to display if items are of pot's type.
 */
fileprivate struct PotsList: View {
    let pots: [Pot]
    @EnvironmentObject var game: GameViewModel
    
    var body: some View {
        Group {
            ForEach(pots, id: \.description) { pot in
                PotCell(pot: pot)
            }
        }
    }
}

// MARK: - SportsList

/**
 List to display if items are of sport's type.
 */
fileprivate struct SportsList: View {
    let sports: [Sport]
    //@State var isItemHidden: [Pot: Bool]
    @EnvironmentObject var game: GameViewModel
    
    var body: some View {
        Group {
            ForEach(sports, id: \.description) { sport in
                SportCell(sport: sport)
                    .canBeDeleted {
                        game.delete(sport)
                    }
            }
        }
    }
}

// MARK: - PerformancesList

/**
 List to display if items are of performance's type.
 */
fileprivate struct PerformancesList<T: NSManagedObject>: View {
    let performances: [Performance]
    @EnvironmentObject var game: GameViewModel
    let source: Athletic?
    
    var body: some View {
        Group {
            ForEach(performances, id: \.description) { performance in
                PerformanceCell(performance: performance)
                    .canBeDeleted {
                        if let source = source {
                            game.delete(performance, of: source)
                        } else {
                            game.delete(performance)
                        }
                    }
            }
        }
    }
}

// MARK: - CanBeDeleted

/**
 Add a context menu with a delete button to delete a cell.
 */
fileprivate struct CanBeDeleted: ViewModifier {
    
    // MARK: - Properties
    
    /// Cell's opacity.
    @State private var opacity: Double = 1
    /// Action to perform when cell's animation is over.
    let deleteAction: () -> Void
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        content
            .contextMenu {
                HStack {
                    Text("deletion.title".localized)
                    Image(systemName: "trash")
                }
                .inButton {
                    withAnimation(.easeIn(duration: 0.5)) {
                        opacity = 0
                    }
                }
            }
            .opacity(opacity)
            .animation(.easeIn)
            .transition(.opacity)
            .onAnimationCompleted(for: opacity, completion: deleteAction)
    }
}

// MARK: - View's Extension

extension View {
    fileprivate func canBeDeleted(deleteAction: @escaping () -> Void) -> some View {
        modifier(CanBeDeleted(deleteAction: deleteAction))
    }
    fileprivate func onAnimationCompleted<Value: VectorArithmetic>(for value: Value, completion: @escaping () -> Void) -> ModifiedContent<Self, OnAnimationCompleted<Value>> {
        return modifier(OnAnimationCompleted(observedValue: value, completion: completion))
    }
    
}

// MARK: - OnAnimationCompleted

struct OnAnimationCompleted<Value>: AnimatableModifier where Value: VectorArithmetic {
    
    /// While animating, SwiftUI changes the old input value to the new target value using this property. This value is set to the old value until the animation completes.
    var animatableData: Value {
        didSet {
            notifyCompletionIfFinished()
        }
    }
    
    /// The target value for which we're observing. This value is directly set once the animation starts. During animation, `animatableData` will hold the oldValue and is only updated to the target value once the animation completes.
    private var targetValue: Value
    
    /// The completion callback which is called once the animation completes.
    private var completion: () -> Void
    
    init(observedValue: Value, completion: @escaping () -> Void) {
        self.completion = completion
        self.animatableData = observedValue
        targetValue = observedValue
    }
    
    /// Verifies whether the current animation is finished and calls the completion callback if true.
    private func notifyCompletionIfFinished() {
        guard animatableData == targetValue else { return }
        
        /// Dispatching is needed to take the next runloop for the completion callback.
        /// This prevents errors like "Modifying state during view update, this will cause undefined behavior."
        DispatchQueue.main.async {
            self.completion()
        }
    }
    
    func body(content: Content) -> some View {
        /// We're not really modifying the view so we can directly return the original input value.
        return content
    }
}
