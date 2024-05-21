import Dependencies

public struct InstallationClient {
    public let getCurrentInstallationId: () -> String
}

extension InstallationClient {
    public static func mock(_ id: String = "1") -> InstallationClient {
        InstallationClient(getCurrentInstallationId: { id })
    }
}

extension InstallationClient: TestDependencyKey {
    public static let testValue = InstallationClient.mock()
}

extension DependencyValues {
    public var installationClient: InstallationClient {
        get { self[InstallationClient.self] }
        set { self[InstallationClient.self] = newValue }
    }
}
