import Dependencies
import StockClient

extension InstallationClient: DependencyKey {
    public static let liveValue = InstallationClient.mock()
}
