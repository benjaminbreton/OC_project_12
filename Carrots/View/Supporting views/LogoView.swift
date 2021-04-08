//
//  LogoView.swift
//  Carrots
//
//  Created by Benjamin Breton on 07/04/2021.
//

import SwiftUI

extension CGFloat {
    func getCorrectSize(for height: CGFloat) -> CGFloat {
        for index in 0...Int(self) {
            if (Int(self) - index) * 2 <= Int(height) {
                return CGFloat(Int(self) - index)
            }
        }
        return 0
    }
}
struct LogoView: View {
    var body: some View {
        EntireCarrot()
    }
}

struct EntireCarrot: View {
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size.width.getCorrectSize(for: geometry.size.height)
            VStack {
                CarrotGreensView()
                CarrotSquare()
            }
            .frame(width: size, height: size * 2, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
}

struct CarrotGreensView: View {
    var body: some View {
        ZStack {
            CarrotGreensShape()
                .foregroundColor(.green)
            CarrotGreensShape()
                .stroke()
                .foregroundColor(.black)
        }
    }
}
struct CarrotGreensShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX / 2, y: rect.maxY))
        path.addCurve(
            to: CGPoint(x: 0, y: rect.maxY / 2),
            control1: CGPoint(x: rect.maxX / 4, y: rect.maxY / 4 * 3), control2: CGPoint(x: rect.maxX / 2, y: rect.maxY / 4 * 3))
        //path.addLine(to: CGPoint(x: 0, y: rect.maxY / 2))
        
        path.addCurve(
            to: CGPoint(x: rect.maxX, y: rect.maxY / 2),
            control1: CGPoint(x: rect.maxX / 2, y: 0), control2: CGPoint(x: rect.maxX / 2, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY / 2))
        
        path.addCurve(
            to: CGPoint(x: rect.maxX / 2, y: rect.maxY),
            control1: CGPoint(x: rect.maxX / 4 * 3, y: rect.maxY / 4 * 3), control2: CGPoint(x: rect.maxX / 4 * 3, y: rect.maxY / 4 * 3))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY / 2))
        
        
        return path
    }
}
struct CarrotSquare: View {
    var body: some View {
        //GeometryReader { geometry in
            ZStack {
                CarrotShape()
                    .foregroundColor(.orange)
                    //.frame(width: min(geometry.size.width, geometry.size.height), height: min(geometry.size.width, geometry.size.height), alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                CarrotShape()
                    .stroke(lineWidth: 5)
                    .foregroundColor(.black)
                    //.frame(width: min(geometry.size.width, geometry.size.height), height: min(geometry.size.width, geometry.size.height), alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
        //}
    }
}

struct CarrotShape: Shape {
    let multiplierControl1Y: CGFloat = 1/64
    let multiplierControl2Y: CGFloat = 1/4
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX / 2, y: 0))
        path.addCurve(
            to: CGPoint(x: rect.maxX / 2, y: rect.maxY),
            control1: CGPoint(x: rect.maxX / 4, y: rect.maxY * multiplierControl1Y),
            control2: CGPoint(x: rect.maxX / 8 * 3, y: rect.maxY * multiplierControl2Y))
        path.addLine(to: CGPoint(x: rect.maxX / 2, y: rect.maxY))
        path.addCurve(
            to: CGPoint(x: rect.maxX / 2, y: 0),
            control1: CGPoint(x: rect.maxX / 8 * 5, y: rect.maxY * multiplierControl2Y),
            control2: CGPoint(x: rect.maxX / 4 * 3, y: rect.maxY * multiplierControl1Y))
        path.addLine(to: CGPoint(x: rect.maxX / 2, y: 0))
        return path
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
