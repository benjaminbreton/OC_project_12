//
//  View + modifiers.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import Foundation
import SwiftUI
extension View {
    func withAppBackground() -> some View {
        modifier(BackgroundView())
    }
    func inCellRectangle() -> some View {
        modifier(CellRectangle())
    }
    func inNoListRectangle() -> some View {
        modifier(NoListRectangle())
    }
    func withTitleFont() -> some View {
        modifier(TitleFont())
    }
    func withSimpleFont() -> some View {
        modifier(SimpleFont())
    }
    func withBigTitleFont() -> some View {
        modifier(BigTitleFont())
    }
    func withNavigationLink<T: View>(destination: T) -> some View {
        modifier(NavigationLinkOnModifier(destination: destination))
    }
    func inNavigationPageView(title: String) -> some View {
        modifier(NavigationPageView(title: title))
    }
    func inButton(action: @escaping () -> Void) -> some View {
        modifier(InButton(action: action))
    }
}