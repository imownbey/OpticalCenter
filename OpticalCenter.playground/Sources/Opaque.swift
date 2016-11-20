import Foundation
import UIKit

extension UIImage {
    public func opaquePoints() -> [CGPoint] {
        guard let rgba = RGBA(image: self) else {
            return []
        }
        
        var points = [CGPoint]()
        for y in 0..<rgba.height {
            for x in 0..<rgba.width {
                let index = y * rgba.width + x
                let pixel = rgba.pixels[index]
                if pixel.alpha > 0 {
                    points.append(CGPoint(x: x, y: y))
                }
            }
        }
        
        return points
    }
}
