import Foundation

public func circleArea(_ radius: Double) -> Double {
    return Double.pi * (pow(max(radius, 0), 2))
}
