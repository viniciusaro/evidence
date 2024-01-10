//
//  SetStatusViewModel.swift
//  
//
//  Created by Cris Messias on 02/12/23.
//

import SwiftUI

public class SetStatusViewModel: ObservableObject, Identifiable {
    public var id = UUID()
    @Published var statusInput: String {
        didSet {
            isClearButtonShowing = false
        }
    }
    @Published var isClearButtonShowing: Bool
    var delegateSaveButtonTapped: (String) -> Void = { _ in fatalError() }
    var delegateCloseButtonTapped: () -> Void = { fatalError() }


    init(statusInput: String = "") {
        self.statusInput = statusInput
        self.isClearButtonShowing = !statusInput.isEmpty
    }

    func clearStatusInputTextFieldTapped() {
        statusInput = ""
    }

    func clearAndSaveButtonTapped() {
        statusInput = ""
        delegateSaveButtonTapped("")
    }

    func saveButtonTapped() {
        delegateSaveButtonTapped(statusInput)
    }

    func closeButtonTapped() {
        delegateCloseButtonTapped()
    }
}
