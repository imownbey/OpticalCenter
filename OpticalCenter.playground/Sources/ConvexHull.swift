// https://en.wikibooks.org/wiki/Algorithm_Implementation/Geometry/Convex_hull/Monotone_chain#Ruby

import Foundation
import CoreGraphics

public class ConvexHull {
    public static func calculate(on points: [CGPoint]) -> [CGPoint] {
        if points.count <= 1 {
            return points
        }
        
        // Lower hull
        var lower = [CGPoint]()
        for p in points {
            while lower.count >= 2 && cross(lower[lower.count - 2], lower[lower.count - 1], p) <= 0 {
                lower.remove(at: lower.count - 1)
            }
            lower.append(p)
        }
        
        // upper hull
        var upper = [CGPoint]()
        for p in points.reversed() {
            while upper.count >= 2 && cross(upper[upper.count - 2], upper[upper.count - 1], p) <= 0 {
                upper.remove(at: upper.count - 1)
            }
            upper.append(p)
        }

        lower.remove(at: lower.count - 1)
        upper.remove(at: upper.count - 1)
        
        return lower + upper
    }

    static func cross(_ o: CGPoint, _ a: CGPoint, _ b: CGPoint) -> CGFloat {
        return (a.x - o.x) * (b.y - o.y) - (a.y - o.y) * (b.x - o.x)
    }
}
