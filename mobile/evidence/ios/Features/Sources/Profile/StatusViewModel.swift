//
//  StatusViewModel.swift
//  Evidence
//
//  Created by Cris Messias on 09/11/23.
//

import SwiftUI
import Models

public class StatusViewModel: ObservableObject {
    @Published private(set) var status: Profile
    @Published var statusInput: String
    @Published private(set) var showModal: Bool
    @Published private(set) var isClearButtonShowing: Bool
    @Published var offSetY: CGFloat
    @Published var popupText: String
    
    public init(status: Profile = .active, statusInput: String = "", showModal: Bool = false, showClearButton: Bool = false, offSetY: CGFloat = 1000, popupText: String = "Set Status") {
        self.status = status
        self.statusInput = statusInput
        self.showModal = showModal
        self.isClearButtonShowing = showClearButton
        self.offSetY = offSetY
        self.popupText = popupText
    }
    
    func statusInputButtonTapped() {
        showModal = true
    }
    
    func modalCloseButtonTapped() {
        showModal = false
    }
    
    func clearStatusInputButtonTapped() {
        statusInput = ""
        isClearButtonShowing = false
        popupText = "Status Cleared"
        popupSaveOrClearActions()
    }
    
    func clearStatusInputTextFieldTapped() {
        statusInput = ""
        isClearButtonShowing = false
        showModal = false
        popupText = "Status Cleared"
        popupSaveOrClearActions()
    }
    
    func saveButtonTapped() {
        if !statusInput.isEmpty {
            isClearButtonShowing = true
            showModal = false
            popupText = "Set Status"
            popupSaveOrClearActions()
        }
    }
    
    func popupSaveOrClearActions() {
        offSetY = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.offSetY = 1000
        }
    }
    
}

