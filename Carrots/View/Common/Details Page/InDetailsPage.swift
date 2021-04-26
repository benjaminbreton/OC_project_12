//
//  InDetailsPage.swift
//  Carrots
//
//  Created by Benjamin Breton on 20/04/2021.
//

import SwiftUI
struct InDetailsPage<T: View>: ViewModifier {
    let title: String
    let destinationToModify: T
    func body(content: Content) -> some View {
        VStack {
            Divider()
            ScrollView(.vertical) {
                content
            }
            Divider()
        }
        .inNavigationPageViewWithButton(title: title, buttonImage: "square.and.pencil", buttonDestination: destinationToModify)
    }
}
extension View {
    func inDetailsPage<T: View>(title: String, destinationToModify: T) -> some View {
        modifier(InDetailsPage(title: title, destinationToModify: destinationToModify))
    }
}



struct DetailsPerformancesDisplayer: View {
    let performances: [FakePerformance]
    var count: Int { performances.count }
    var body: some View {
        VStack {
            Text("Performances")
                .withTitleFont()
            HStack {
                Text("Count : ")
                Text("\(count)")
                    .inRectangle(.leading)
            }
            .withSimpleFont()
            if performances.count > 0 {
                Divider()
                ListBase(items: performances.map({ PerformanceCell(performance: $0)}))
                    .frame(height: ViewCommonSettings().textLineHeight * 2 * (CGFloat(performances.count + 1)))
            }
        }
    }
}
