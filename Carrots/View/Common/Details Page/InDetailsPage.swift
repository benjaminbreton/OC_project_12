//
//  InDetailsPage.swift
//  Carrots
//
//  Created by Benjamin Breton on 20/04/2021.
//

import SwiftUI
struct InDetailsPage<T: View>: ViewModifier {
    let genericTitle: String
    let specificTitle: String
    let destinationToModify: T
    func body(content: Content) -> some View {
        VStack {
            Divider()
            HStack {
                Text(specificTitle)
                    .withBigTitleFont()
                Image(systemName: "square.and.pencil")
                    .withNavigationLink(destination: destinationToModify)
                    .withLinkFont()
            }
            Divider()
            ScrollView(.vertical) {
                content
            }
            Divider()
        }
        .inNavigationPageView(title: genericTitle)
    }
}
extension View {
    func inDetailsPage<T: View>(genericTitle: String, specificTitle: String, destinationToModify: T) -> some View {
        modifier(InDetailsPage(genericTitle: genericTitle, specificTitle: specificTitle, destinationToModify: destinationToModify))
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
            .padding()
            if performances.count > 0 {
                Divider()
                ListBase(items: performances.map({ PerformanceCell(performance: $0)}))
                    .frame(height: ViewCommonSettings().textLineHeight * 2 * (CGFloat(performances.count + 1)))
            }
        }
    }
}
