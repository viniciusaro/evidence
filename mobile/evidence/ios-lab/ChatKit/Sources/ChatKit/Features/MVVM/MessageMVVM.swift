import Combine
import SwiftUI

class MessageModel: ObservableObject, Identifiable {
    @Published var message: Message
    @Published var user: User
    
    var id: MessageID { message.id }
    
    private var previewCancellable: AnyCancellable? = nil
    
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
        guard
            let url = URL(string: message.content),
            url.host() != nil,
            message.preview == nil else {
            return
        }
        
        previewCancellable?.cancel()
        previewCancellable = URLPreviewClient.live
            .get(url)
            .receive(on: DispatchQueue.main)
            .filter { $0 != nil }
            .map { $0! }
            .map { Preview(image: $0.image, title: $0.title) }
            .sink { [weak self] in self?.onPreviewDidLoad($0) }
    }
    
    private func onPreviewDidLoad(_ preview: Preview) {
        message.preview = preview
    }
}

struct MessageViewMVVM: View {
    @ObservedObject var model: MessageModel
    
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
