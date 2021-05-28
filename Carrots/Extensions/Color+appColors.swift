//
//  Color+appColors.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
extension Color {
    static var text: Color { Color("black") }
    static var backgroundFirst: Color { Color("lightGrey") }
    static var backgroundSecond: Color { Color("lightOrange") }
    static var alertBlockBackground: Color { Color("white").opacity(0.8) }
    static var alertBlockShape: Color { Color("lightGrey").opacity(0.8) }
    static var alertBlockImage: Color { Color("green") }
    static var alertBlockText: Color { Color("grey") }
    static var link: Color { Color("green") }
    static var tab: Color { Color("green") }
    static var image: Color { Color("orange") }
    static var backCell: Color { Color("white").opacity(0.3) }
    static var title: Color { Color("orange") }
    static var textLight: Color { Color("grey") }
    static var graphFirst: Color { Color("lightOrange") }
    static var graphSecond: Color { Color("darkGrey") }
    static var delete: Color { Color("red") }
}
