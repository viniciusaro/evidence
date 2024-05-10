import AuthClient
import ComposableArchitecture
import Models
import PreviewClient
import SwiftUI

struct MessageView: View {
    var user: User
    @Binding var message: Message
    
    var alignment: HorizontalAlignment {
        message.sender.id == user.id ? .trailing : .leading
    }
    
    var textAlignment: TextAlignment {
        return message.sender.id == user.id ? .trailing : .leading
    }
    
    var frameAlignment: Alignment {
        return message.sender.id == user.id ? .trailing : .leading
    }
    
    var body: some View {
        VStack(alignment: alignment) {
            HStack {
                VStack(alignment: alignment) {
                    Text(message.content)
                        .frame(maxWidth: .infinity, alignment: frameAlignment)
                    Text(message.sender.name).font(.caption2)
                        .frame(maxWidth: .infinity, alignment: frameAlignment)
                    if message.isSent {
                        Label("", systemImage: "checkmark")
                            .labelStyle(.iconOnly)
                            .font(.caption2)
                            .foregroundStyle(Color.gray)
                    }
                }
                .multilineTextAlignment(textAlignment)
            }
            if let preview = message.preview {
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
    }
}
