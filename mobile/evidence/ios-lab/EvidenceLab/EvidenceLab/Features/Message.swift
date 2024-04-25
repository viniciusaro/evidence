import ComposableArchitecture
import SwiftUI

//struct MessageView: View {
//    let store: StoreOf<MessageFeature>
//    
//    var body: some View {
//        VStack(alignment: store.alignment) {
//            HStack {
//                VStack(alignment: store.alignment) {
//                    Text(store.message.content)
//                        .frame(maxWidth: .infinity, alignment: store.frameAlignment)
//                    Text(store.message.sender.name).font(.caption2)
//                        .frame(maxWidth: .infinity, alignment: store.frameAlignment)
//                    if store.message.isSent {
//                        Label("", systemImage: "checkmark")
//                            .labelStyle(.iconOnly)
//                            .font(.caption2)
//                            .foregroundStyle(Color.gray)
//                    }
//                }
//                .multilineTextAlignment(store.textAlignment)
//            }
//            if let preview = store.message.preview {
//                AsyncImage(url: preview.image) { phase in
//                    if let image = phase.image {
//                        image.resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .clipped()
//                    } else {
//                        VStack {}
//                    }
//                }
//            }
//        }
//        .onViewDidLoad {
//            store.send(.viewDidLoad)
//        }
//    }
//}
