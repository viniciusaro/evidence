import SwiftUI

///
public protocol LeafAvatarStyle {
    associatedtype Body : View
    
    func makeBody(configuration: Self.Configuration) -> Self.Body
    
    typealias Configuration = LeafAvatarConfiguration
}

///
public struct LeafAvatarConfiguration {
    public let avatar: AnyView
}

///
extension LeafAvatarStyle where Self == AutomaticLeafAvatarStyle {
    public static var automatic: Self { .init() }
}

extension LeafAvatarStyle where Self == EvidentLeafAvatarStyle {
    public static var evident: Self { .init() }
}

///
public struct AutomaticLeafAvatarStyle: LeafAvatarStyle {
    private let size = CGSize(width: 43, height: 43)
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.avatar
            .frame(width: size.width, height: size.height)
            .cornerRadius(size.width/2)
            .overlay {
                Circle().stroke(.tint, lineWidth: 3)
            }
    }
}

///
public struct EvidentLeafAvatarStyle: LeafAvatarStyle {
    private let size = CGSize(width: 64, height: 64)
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.avatar
            .frame(width: size.width, height: size.height)
            .cornerRadius(size.width/2)
            .overlay {
                Circle().stroke(.tint, lineWidth: 3)
            }
    }
}

///
public struct LeafAvatarStyleKey: EnvironmentKey {
    public static let defaultValue: any LeafAvatarStyle = .automatic
}

extension EnvironmentValues {
    public var leafAvatarStyle: any LeafAvatarStyle {
        get { self[LeafAvatarStyleKey.self] }
        set { self[LeafAvatarStyleKey.self] = newValue }
    }
}

extension View {
    public func avatarStyle<S>(_ style: S) -> some View where S: LeafAvatarStyle {
        environment(\.leafAvatarStyle, style)
    }
}
