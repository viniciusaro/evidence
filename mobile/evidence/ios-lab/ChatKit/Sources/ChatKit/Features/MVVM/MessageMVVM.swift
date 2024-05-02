import SwiftUI

@Observable
class MessageModel: Identifiable {
    var message: Message
    var user: User
    var id: MessageID { message.id }
    
    var alignment: HorizontalAlignment {
        message.sender.id == user.id ? .trailing : .leading
    }
    
    var textAlignment: TextAlignment {
        return message.sender.id == user.id ? .trailing : .leading
    }
    
    var frameAlignment: Alignment {
        return message.sender.id == user.id ? .trailing : .leading
    }
    
    init(message: Message) {
        self.message = message
        self.user = authClient.getAuthenticatedUser() ?? User()
    }
    
    func onViewDidLoad() {
        
    }
}

struct MessageViewMVVM: View {
    let model: MessageModel
    
    var body: some View {
        VStack(alignment: model.alignment) {
            HStack {
                VStack(alignment: model.alignment) {
                    Text(model.message.content)
                        .frame(maxWidth: .infinity, alignment: model.frameAlignment)
                    Text(model.message.sender.name).font(.caption2)
                        .frame(maxWidth: .infinity, alignment: model.frameAlignment)
                    if model.message.isSent {
                        Label("", systemImage: "checkmark")
                            .labelStyle(.iconOnly)
                            .font(.caption2)
                            .foregroundStyle(Color.gray)
                    }
                }
                .multilineTextAlignment(model.textAlignment)
            }
            if let preview = model.message.preview {
                AsyncImage(url: preview.image) { phase in
                    if let image = phase.image {
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipped()
                    } else {
                        VStack {}
                    }
                }
            }
        }
        .onViewDidLoad {
            model.onViewDidLoad()
        }
    }
}
