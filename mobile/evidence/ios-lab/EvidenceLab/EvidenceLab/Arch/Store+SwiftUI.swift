//import Combine
//import SwiftUI
//
//struct WithViewStore<State, Action>: View {
//    @ObservedObject private var viewStore: ViewStore<State, Action>
//    private let viewBuilder: (ViewStore<State, Action>) -> any View
//    
//    init(
//        store: Store<State, Action>,
//        @ViewBuilder viewBuilder: @escaping (ViewStore<State, Action>) -> any View
//    ) {
//        self.viewStore = ViewStore(store: store)
//        self.viewBuilder = viewBuilder
//    }
//    
//    var body: some View {
//        AnyView(self.viewBuilder(self.viewStore))
//    }
//}
