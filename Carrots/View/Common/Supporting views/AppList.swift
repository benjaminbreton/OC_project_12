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
    
    /// Boolean indicating whether help texts are shown or not.
    @State private var showHelp: Bool = false
    /// Items to display.
    private let items: [T]
    /// Text to display if items property is empty.
    private let placeholder: String
    /// List's title.
    private let title: String?
    /// Common pot to display in a pots list.
    private let commonPot: Pot?
    /// A boolean indicating whether dividers have to be added at the list's top and bottom.
    private let withDivider: Bool
    /// Text to show if user is asking for help.
    private let helpText: String?
    /// If this list is an athletic's performances list, the source is the athletic.
    private let source: Athletic?
    
    // MARK: - Init
    
    init(_ items: [T], placeholder: String, commonPot: Pot? = nil, title: String? = nil, withDivider: Bool = true, helpText: String? = nil, source: Athletic? = nil) {
        self.items = items
        self.placeholder = placeholder
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
            // help
            if let text = helpText {
                HelpView(text: text, isShown: $showHelp)
            }
            // list's scroll view
            ScrollView(withDivider ? .vertical : []) {
                if items.count > 0 {
                    // display common pot before others in case of pots list
                    if let commonPot = commonPot {
                        PotCell(commonPot)
                            .inNavigationLink(
                                PotAddings(commonPot)
                            )
                    }
                    // display list's title
                    if let title = title {
                        Text(title)
                            .withTitleFont()
                    }
                }
                // display the list
                SimpleList(items: items, placeholder: placeholder, source: source)
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
    
    /// Items to display.
    private let items: [T]
    /// Text to display if items property is empty.
    private let placeholder: String
    /// If this list is an athletic's performances list, the source is the athletic.
    private let source: Athletic?
    /// A boolean indicating whether the placeholder has to be displayed or not.
    private var isPlaceholderVisible: Bool { items.count == 0 }
    
    // MARK: - Init
    
    init(items: [T], placeholder: String, source: Athletic?) {
        self.items = items
        self.placeholder = placeholder
        self.source = source
    }
    
    // MARK: - Body
    
    var body: some View {
        Group {
            // look for the list type ...
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
            // if no elements in the list, display placeholder
            if isPlaceholderVisible {
                Text(placeholder)
                    .withSimpleFont()
                    .inRectangle(.topLeading)
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
    
    // MARK: - Properties
    
    /// The ViewModel.
    @EnvironmentObject private var game: GameViewModel
    /// Items to display.
    private let athletics: [Athletic]
    
    // MARK: - Init
    
    init(athletics: [Athletic]) {
        self.athletics = athletics
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            ForEach(athletics, id: \.description) { athletic in
                AthleticCell(athletic)
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
    
    // MARK: - Properties
    
    /// The ViewModel.
    @EnvironmentObject private var game: GameViewModel
    /// Items to display.
    private let pots: [Pot]
    
    // MARK: - Init
    
    init(pots: [Pot]) {
        self.pots = pots
    }
    
    // MARK: - Body
    
    var body: some View {
        Group {
            ForEach(pots, id: \.description) { pot in
                PotCell(pot)
            }
        }
    }
}

// MARK: - SportsList

/**
 List to display if items are of sport's type.
 */
fileprivate struct SportsList: View {
    
    // MARK: - Properties
    
    /// The ViewModel.
    @EnvironmentObject private var game: GameViewModel
    /// Items to display.
    private let sports: [Sport]
    
    // MARK: - Init
    
    init(sports: [Sport]) {
        self.sports = sports
    }

    // MARK: - Body
    
    var body: some View {
        Group {
            ForEach(sports, id: \.description) { sport in
                SportCell(sport)
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

    // MARK: - Properties
    
    /// The ViewModel.
    @EnvironmentObject private var game: GameViewModel
    /// Boolean indicating whether older performances than today can be displayed or not.
    @State var areOlderPerformancesHidden: Bool = true
    /// Items to display.
    private let performances: [Performance]
    /// If this list is an athletic's performances list, the source is the athletic.
    private let source: Athletic?
    /// Performances of performances property recorded today.
    private var todaysPerformances: [Performance] {
        performances.map({ $0.date.unwrapped >= Date().today ? $0 : nil }).compactMap({ $0 })
    }
    /// Performances of performances property recorded before today.
    private var olderPerformances: [Performance] {
        performances.map({ $0.date.unwrapped >= Date().today ? nil : $0 }).compactMap({ $0 })
    }
    
    // MARK: - Init
    
    init(performances: [Performance], source: Athletic?) {
        self.performances = performances
        self.source = source
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            // toggle to choose between display older performances or not
            Toggle("performances.hide".localized, isOn: $areOlderPerformancesHidden)
                .withLightSimpleFont()
                .inRectangle(.leading)
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            // today's performances list
            if todaysPerformances.count > 0 {
                ForEach(todaysPerformances, id: \.description) { performance in
                    PerformanceCell(performance)
                        .canBeDeleted {
                            if let source = source {
                                // delete performance for the athletic
                                game.delete(performance, of: source)
                            } else {
                                // delete performance
                                game.delete(performance)
                            }
                        }
                }
            } else {
                Text("performances.todaysNone".localized)
                    .withLightSimpleFont()
                    .inRectangle(.leading)
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            }
            // older performances list
            if !areOlderPerformancesHidden {
                ForEach(olderPerformances, id: \.description) { performance in
                    PerformanceCell(performance)
                        .canBeDeleted {
                            if let source = source {
                                // delete performance for the athletic
                                game.delete(performance, of: source)
                            } else {
                                // delete performance
                                game.delete(performance)
                            }
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
            // the menu for cell's deletion
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
            // the cell's opacity depending on animation
            .opacity(opacity)
            // transition's type
            .transition(.opacity)
            // wait for the opacity's animation to be completed before performing the action
            .onAnimationCompleted(for: opacity, completion: deleteAction)
    }
}

// MARK: - View's Extension

fileprivate extension View {
    /**
     Add a context menu with a delete button to delete a cell.
     - parameter deleteAction: The action to perform when deletion has been asked.
     - returns: The cell with the deletion menu.
     */
    func canBeDeleted(deleteAction: @escaping () -> Void) -> some View {
        modifier(CanBeDeleted(deleteAction: deleteAction))
    }
    /**
     Wait for the content's animation to be completed before performing some actions.
     - parameter value: Value to use to watch the animation.
     - parameter completion: The action to perform when animation has been completed.
     - returns: The content with this observer.
     */
    func onAnimationCompleted<Value: VectorArithmetic>(for value: Value, completion: @escaping () -> Void) -> ModifiedContent<Self, OnAnimationCompleted<Value>> {
        return modifier(OnAnimationCompleted(observedValue: value, completion: completion))
    }
    
}

// MARK: - OnAnimationCompleted

/**
 Wait for the content's animation to be completed before performing some actions.
 */
fileprivate struct OnAnimationCompleted<Value>: AnimatableModifier where Value: VectorArithmetic {
    
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
