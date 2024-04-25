import ComposableArchitecture
import SwiftUI

//struct ChatDetailView: View {
//    let store: StoreOf<ChatDetailFeature>
//    
//    var body: some View {
//        VStack {
//            List {
//                ForEach(store.scope(state: \.messages, action: \.message)) { store in
//                    MessageView(store: store)
//                }
//            }
//            HStack(spacing: 12) {
//                Button(action: {
//                    
//                }, label: {
//                    Label("", systemImage: "plus")
//                        .labelStyle(.iconOnly)
//                        .font(.title)
//                        .foregroundStyle(.primary)
//                })
//                TextField("", text: Binding(
//                    get: { store.inputText },
//                    set: { store.send(.inputTextUpdated($0)) }
//                ))
//                .frame(height: 36)
//                .padding([.leading, .trailing], 8)
//                .background(RoundedRectangle(cornerRadius: 18)
//                    .fill(Color(red: 43/255, green: 43/255, blue: 43/255))
//                )
//                Button(action: {
//                    store.send(.send)
//                }, label: {
//                    Label("", systemImage: "arrow.forward.circle.fill")
//                        .labelStyle(.iconOnly)
//                        .font(.largeTitle)
//                        .foregroundStyle(.white, .primary)
//                })
//            }
//            .padding(10)
//            .background(Color(red: 20/255, green: 20/255, blue: 20/255))
//        }
//        .listStyle(.plain)
//        .navigationTitle(store.title)
//    }
//}
