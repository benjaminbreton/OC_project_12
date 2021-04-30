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
        modifier(WithBackground())
    }
    func inCellRectangle() -> some View {
        modifier(InCellRectangle())
    }
    func inRectangle(_ alignment: Alignment) -> some View {
        modifier(InRectangle(alignment: alignment))
    }
    func withTitleFont() -> some View {
        modifier(TitleFont())
    }
    func withSimpleFont() -> some View {
        modifier(SimpleFont())
    }
    func withLightSimpleFont() -> some View {
        modifier(LightSimpleFont())
    }
    func withBigSimpleFont() -> some View {
        modifier(BigSimpleFont())
    }
    func withLinkFont() -> some View {
        modifier(LinkFont())
    }
    func withBigTitleFont() -> some View {
        modifier(BigTitleFont())
    }
    func withSportIconFont(lineCount: CGFloat) -> some View {
        modifier(SportIconFont(lineCount: lineCount))
    }
    func withNavigationLink<T: View>(destination: T) -> some View {
        modifier(WithNavigationLink(destination: destination))
    }
    func inNavigationPageView(title: String) -> some View {
        modifier(NavigationPageView(title: title))
    }
    func inButton(action: @escaping () -> Void) -> some View {
        modifier(InButton(action: action))
    }
    func inSettingsPage(_ title: String, confirmAction: @escaping () -> Void) -> some View {
        modifier(InSettingsPage(title: title, confirmAction: confirmAction))
    }
    func closeKeyboardOnTap() -> some View {
        modifier(CloseKeyboardOnTap())
    }
}
