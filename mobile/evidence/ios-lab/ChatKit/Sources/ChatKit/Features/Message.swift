import AuthClient
import ComposableArchitecture
import Leaf
import Models
import PreviewClient
import SwiftUI

#Preview {
    LeafThemeView {
        NavigationStack {
            ChatDetailView(store: Store(
                initialState: .init(
                    chat: Shared(.evidence),
                    inputText: "/",
                    commandSelectionList: Plugin.openAI.commands
                )
            ) {
                ChatDetailFeature()
            })
        }
    }
}

struct MessageView: View {
    var user: User
    @Binding var message: Message
    @Environment(\.leafTheme) var theme
    
    var alignment: HorizontalAlignment {
        message.sender.id == user.id ? .trailing : .leading
    }
    
    var textAlignment: TextAlignment {
        return message.sender.id == user.id ? .trailing : .leading
    }
    
    var frameAlignment: Alignment {
        return message.sender.id == user.id ? .trailing : .leading
    }
    
    var isMe: Bool {
        return message.sender.id == user.id
    }
    
    var body: some View {
        HStack {
            if isMe {
                Spacer().frame(width: 60)
                Spacer()
            }
            VStack(alignment: alignment) {
                Text(message.content)
                    .frame(alignment: frameAlignment)
                Text(message.sender.name).font(.caption2)
                    .frame(alignment: frameAlignment)
                if message.isSent {
                    Label("", systemImage: "checkmark")
                        .labelStyle(.iconOnly)
                        .font(.caption2)
                        .foregroundStyle(Color.gray)
                }
                if let preview = message.preview {
                    LeafAsyncImage(url: preview.image) { status in
                        switch status {
                        case .loading:
                            EmptyView()
                        case .loaded(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipped()
                        case .error:
                            VStack {}
                        }
                    }
                }
            }
            .frame(alignment: frameAlignment)
            .multilineTextAlignment(textAlignment)
            .padding(isMe ? 8 : 0)
            .background(RoundedRectangle(cornerRadius: 4)
                .fill(isMe ?
                      theme.color.backgrond.background :
                        Color.white.opacity(0.0)
                     )
            )
            if !isMe {
                Spacer()
                Spacer().frame(width: 60)
            }
        }
    }
}
