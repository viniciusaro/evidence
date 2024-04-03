import SwiftUI

protocol ViewModel: AnyObject, Equatable, Hashable {}

extension ViewModel {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs === rhs
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(ObjectIdentifier(self))
    }
}
