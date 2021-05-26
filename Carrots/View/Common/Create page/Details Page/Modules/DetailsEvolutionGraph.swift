//
//  DetailsEvolutionGraph.swift
//  Carrots
//
//  Created by Benjamin Breton on 20/04/2021.
//

import SwiftUI

// MARK: - Container

/**
 Graphic which represents an array of EvolutionData.
 */
struct DetailsEvolutionGraph: View {
    
    // MARK: - Properties
    
    /// Boolean indicating whether graphic's help text is shown or not.
    @State var helpIsShown: Bool = false
    /// Module's title.
    private let title: String
    /// Datas to display
    private let datas: [EvolutionData]
    /// Graphic's description.
    private let description: String
    /// Graphic's height.
    private let height: CGFloat = ViewCommonSettings().commonSizeBase * 12
    /// Minimum and maximum formatted values of datas.
    private var values: (min: String, max: String) {
        // check if min and max values can be getted
        guard let max = datas.map({ $0.value }).max(), let min = minValue == nil ? datas.map({ $0.value }).min() : minValue else { return (min: "---", max: "---") }
        // prepare formatter
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale.current
        // returns formatted values
        return (min: formatter.string(from: NSNumber(value: min)) ?? "---", max: formatter.string(from: NSNumber(value: max)) ?? "---")
    }
    /// Minimum value determination used by the *values* property.
    private var minValue: Double? {
        // are there sufficients datas ?
        guard datas.count > 1 else { return nil }
        // check first dates
        guard let firstDate = datas[0].date, let secondDate = datas[1].date else { return nil }
        // get the minimum possible date (30 days ago)
        let minDate = Date().today - 30 * 3600 * 24
        // check if the first date is older than the minimum possible
        if firstDate < minDate {
            // compute the value of the minimum possible date
            let firstDuration = DateInterval(start: firstDate, end: minDate).duration
            let secondDuration = DateInterval(start: firstDate, end: secondDate).duration
            return datas[0].value + ((datas[1].value - datas[0].value) / secondDuration) * firstDuration
        } else {
            // the minValue is the firstDate's value, no calculation is needed, returns nil
            return nil
        }
    }
    
    // MARK: - Init
    
    init(title: String, datas: [EvolutionData], description: String) {
        self.title = title
        self.datas = datas
        self.description = description
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            // display help
            HelpView(text: "graphic", isShown: $helpIsShown)
            // display graph
            ZStack {
                if datas.count < 2 {
                    // no graphic can be displayed
                    VStack {
                        Text("graphic.noEvolution".localized)
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
                            .stroke(lineWidth: ViewCommonSettings().graphLineWidth)
                            .fill(LinearGradient(gradient: Gradient(colors: [.graphFirst, .graphSecond]), startPoint: .leading, endPoint: .trailing))
                    }
                }
                // frame's rectangle
                Rectangle()
                    .stroke(lineWidth: ViewCommonSettings().graphLineWidth)
                    .foregroundColor(.graphFirst)
                
            }
            .frame(height: height)
        }
        .inModule(title)
        
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
    /// First date : 30 days ago.
    private var minDate: Date {
        return Date().today - totalTime
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

