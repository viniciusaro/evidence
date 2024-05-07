import AuthClient

#if DEBUG
var authClient = AuthClient.authenticated()
var dataClient = DataClient.live
var stockClient = StockClient.live
var installationClient = InstallationClient.mock("1")
#else
let authClient = AuthClient.live
let dataClient = DataClient.live
let stockClient = StockClient.live
let installationClient = InstallationClient.mock("1")
#endif
