//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

func showPath(for points: [CGPoint]) -> UIBezierPath {
    let path = UIBezierPath()
    if points.count == 0 {
        return path
    }
    
    path.move(to: points.first!)
    for point in points {
        path.addLine(to: point)
    }
    return path
}

let image = UIImage(named: "icon")!
let opaque = image.opaquePoints()
showPath(for: opaque)

let convex = ConvexHull.calculate(on: opaque)
showPath(for: convex)

let circle = Circle.makeWithPoints(points: convex)!
UIBezierPath(arcCenter: circle.center, radius: circle.radius, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI_2 + M_PI), clockwise: true)
