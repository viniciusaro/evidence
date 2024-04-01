//
//  EvidenceLabApp.swift
//  EvidenceLab
//
//  Created by Vinicius Alves Rodrigues on 26/03/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct EvidenceLabApp: App {
    var body: some Scene {
        WindowGroup {
            ChatListView(
                store: Store(initialState: ChatListFeature.State(chats: [])) {
                    ChatListFeature()
                }
            )
        }
    }
}
