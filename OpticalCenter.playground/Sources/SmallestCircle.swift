// Translated from
// https://www.nayuki.io/page/smallest-enclosing-circle

import Foundation
import UIKit

func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

extension CGPoint {
    func distance(to other: CGPoint) -> CGFloat {
        return hypot(x - other.x, y - other.y)
    }
    
    func cross(with other: CGPoint) -> CGFloat {
        return x * other.y - y * other.y
    }
    
    func norm() -> CGFloat {
        return x * x + y * y
    }
}

public struct Circle {
    let EPSILON = CGFloat(DBL_EPSILON)
    public let center: CGPoint
    public let radius: CGFloat
    
    init(center: CGPoint, radius: CGFloat) {
        self.center = center
        self.radius = radius
    }
    
    static func makeCircumcircle(with a: CGPoint, _ b: CGPoint, _ c: CGPoint) -> Circle? {
        let d = ((a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y)) * 2)
        if d == 0 {
            return nil
        }
        
        let x = ((a.norm() * (b.y - c.y) + b.norm() * (c.y - a.y) + c.norm() * (a.y - b.y)) / d)
        let y = ((a.norm() * (c.x - b.x) + b.norm() * (a.x - c.x) + c.norm() * (b.x - a.x)) / d)
        
        let point = CGPoint(x: x, y: y)
        return Circle(center: point, radius: point.distance(to: a))
    }
    
    static func makeDiameter(_ a: CGPoint, _ b: CGPoint) -> Circle {
        return Circle(center: CGPoint(x: ((a.x + b.x) / 2), y: ((a.y + b.y) / 2)), radius: a.distance(to: b) / 2)
    }
    
    static func makeWithTwoPoints(_ points: [CGPoint], _ p: CGPoint, _ q: CGPoint) -> Circle {
        let temp = Circle.makeDiameter(p, q)
        if temp.contains(points: points) {
            return temp
        }
        
        var left: Circle?
        var right: Circle?
        for r in points {
            let pq = q - p
            let cross = pq.cross(with: r - p)
            let c = Circle.makeCircumcircle(with: p, q, r)
            if c == nil {
                continue
            } else if cross > 0 && (left == nil || (pq.cross(with: c!.center - p) > pq.cross(with: left!.center - p))) {
                left = c
            } else if cross < 0 && (right == nil || (pq.cross(with: c!.center - p) < pq.cross(with: right!.center - p))) {
                right = c
            }
        }
        return (right == nil || (left != nil && left!.radius <= right!.radius)) ? left! : right!
    }
    
    static func makeWithOnePoint(points: [CGPoint], p: CGPoint) -> Circle {
        var c = Circle(center: p, radius: 0)
        for (i, q) in points.enumerated() {
            if !c.contains(point: q) {
                if c.radius == 0 {
                    c = Circle.makeDiameter(p, q)
                } else  {
                    let slice = Array(points.prefix(through: i))
                    c = Circle.makeWithTwoPoints(slice, p, q)
                }
            }
        }
        return c
    }
    
    public static func makeWithPoints(points: [CGPoint]) -> Circle? {
        let shuffled = points.shuffled()
        var c: Circle?
        for (i, p) in shuffled.enumerated() {
            if (c == nil || !c!.contains(point: p)) {
                c = Circle.makeWithOnePoint(points: Array(shuffled.prefix(through: i)), p: p)
            }
        }
        return c
    }
    
    func contains(point: CGPoint) -> Bool {
        return point.distance(to: center) <= radius + EPSILON
    }
    
    func contains(points: [CGPoint]) -> Bool {
        for p in points {
            if !contains(point: p) {
                return false
            }
        }
        
        return true
    }
}

extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
