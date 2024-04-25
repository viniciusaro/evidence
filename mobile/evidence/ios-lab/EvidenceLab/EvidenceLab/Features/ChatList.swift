import ComposableArchitecture
import SwiftUI

//struct ChatListView: View {
//    let store: StoreOf<ChatListFeature>
//    
//    var body: some View {
//        List {
//            ForEach(store.chats) { chat in
//                Button(action: {
//                    store.send(.onListItemTapped(chat))
//                }, label: {
//                    VStack(alignment: .leading) {
//                        Text(chat.name)
//                        if let content = chat.messages.last?.content {
//                            Text(content).font(.caption)
//                        }
//                    }
//                    EmptyView()
//                })
//            }
//            .onDelete { indexSet in
//                store.send(.onListItemDelete(indexSet))
//            }
//        }
//        .animation(.bouncy, value: store.chats)
//        .listStyle(.plain)
//        .onViewDidLoad {
//            store.send(.onViewDidLoad)
//        }
//    }
//}
