//
//  DetailsEvolutionGraph.swift
//  Carrots
//
//  Created by Benjamin Breton on 20/04/2021.
//

import SwiftUI

// MARK: - Container

/// Graphic which represents an array of EvolutionData.
struct DetailsEvolutionGraph: View {
    
    // MARK: - Properties
    
    let title: String
    let datas: [EvolutionData]
    let description: String
    private let height: CGFloat = ViewCommonSettings().commonHeight * 12
    /// Minimum and maximum values of datas.
    private var values: (min: String, max: String) {
        guard let max = datas.map({ $0.value }).max(), let min = datas.map({ $0.value }).min() else { return (min: "---", max: "---") }
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale.current
        return (min: formatter.string(from: NSNumber(value: min)) ?? "---", max: formatter.string(from: NSNumber(value: max)) ?? "---")
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            // title
            Text(title)
                .withTitleFont()
            // graphic's frame
            ZStack {
                if datas.count < 2 {
                    // no graphic can be displayed
                    VStack {
                        Text("No evolution can be displayed the first day.")
                            .withLightSimpleFont()
                    }
                } else {
                    // graphic
                    VStack {
                        // description
                        Text("\(description)\nmin.: \(values.min) - max.: \(values.max)")
                            .withLightSimpleFont()
                        // graphic itself
                        EvolutionGraph(datas: datas)
                            .stroke(lineWidth: ViewCommonSettings().shapeLine)
                            .fill(LinearGradient(gradient: Gradient(colors: [.graphFirst, .graphSecond]), startPoint: .leading, endPoint: .trailing))
                    }
                }
                // frame's rectangle
                Rectangle()
                    .stroke(lineWidth: ViewCommonSettings().shapeLine)
                    .foregroundColor(.graphFirst)
                
            }
            .frame(height: height)
            .padding()
        }
    }
}

// MARK: - Graphic's shape

fileprivate struct EvolutionGraph: Shape {
    
    // MARK: - UnwrappedData typealias
    
    typealias UnwrappedData = (date: Date, value: Double)
    
    // MARK: - Properties
    
    let datas: [EvolutionData]
    /// Duration represented by the graphic : 30 days (used to add points on the x axis).
    private let totalTime: Double = 30 * 24 * 3600
    /// Datas presenting an unwrapped date.
    private var unwrappedDatas: [UnwrappedData] {
        datas.map( { (date: $0.date ?? Date(), value: $0.value) } )
    }
    /// Datas maximum value (used to add points on the y axis).
    private var maxValue: Double {
        guard let max = datas.map({ $0.value }).max() else { return 1 }
        return max * 1.5
    }
    private var today: Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: Date())
    }
    /// First date : 30 days ago.
    private var minDate: Date {
        return today - totalTime
    }
    
    // MARK: - Drawing the shape
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // get points to add to the shape
        let points = getPoints(in: rect)
        // get origin point
        let start = getStartPoints(in: rect)
        // move to origin
        path.move(to: start.origin)
        // draw lines
        path.addLine(to: start.firstPoint)
        for point in points {
            path.addLine(to: point)
        }
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: start.origin)
        // return result
        return path
    }
    
    // MARK: - Get start points
    
    /// Returns start points : the first is the origin on the x axis, the second is the first point of the graphic.
    private func getStartPoints(in rect: CGRect) -> (origin: CGPoint, firstPoint: CGPoint) {
        let firstData = unwrappedDatas[0]
        if firstData.date >= minDate {
            return (origin:
                        CGPoint(
                            x: x(for: firstData.date, maxX: Double(rect.maxX)),
                            y: Double(rect.maxY)),
                    firstPoint: point(for: firstData, in: rect)
            )
        }
        let secondData = unwrappedDatas[1]
        let y = getYForXZero(firstData: firstData, secondData: secondData, rect: rect)
        return (origin: CGPoint(x: 0, y: rect.maxY), firstPoint: CGPoint(x: 0, y: y))
    }
    /// Use the first datas to determinate the y value for x = 0.
    private func getYForXZero(firstData pointA: UnwrappedData, secondData pointB: UnwrappedData, rect: CGRect) -> Double {
        // get x and y for the first points
        let xA = x(for: pointA.date, maxX: Double(rect.maxX))
        let xB = x(for: pointB.date, maxX: Double(rect.maxX))
        let yA = y(for: pointA.value, maxY: Double(rect.maxY))
        let yB = y(for: pointB.value, maxY: Double(rect.maxY))
        // get a for the function f(x) = ax + b
        let a = (yB - yA) / (xB - xA)
        // get b for this function : b = -a * x(A) + y(A) = y(0), b is the needed value
        return -1 * a * xA + yA
    }
    
    // MARK: - Get all points
    
    /// Get all points from datas, except the first one.
    private func getPoints(in rect: CGRect) -> [CGPoint] {
        var points =  unwrappedDatas.map({ point(for: $0, in: rect) })
        // the first point is treated by getStartPoints method, so it needs to be removed
        points.remove(at: 0)
        return points
    }
    
    // MARK: - Get single point
    
    /// Get a point in the graph from its data.
    private func point(for data: UnwrappedData, in rect: CGRect) -> CGPoint {
        return CGPoint(
            x: x(for: data.date, maxX: Double(rect.maxX)),
            y: y(for: data.value, maxY: Double(rect.maxY)))
    }
    private func x(for date: Date, maxX: Double) -> Double {
        if minDate <= date {
            return DateInterval(start: minDate, end: date).duration / totalTime * maxX
        } else {
            return DateInterval(start: date, end: minDate).duration / totalTime * maxX * -1
        }
    }
    private func y(for value: Double, maxY: Double) -> Double {
        return (maxValue - value) / maxValue * maxY
    }
    
}

