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
    @Published private(set) var isModalShowing: Bool
    @Published private(set) var isClearButtonShowing: Bool
    @Published var offSetY: CGFloat
    @Published var popupText: String
    
    public init(status: Profile = .active, statusInput: String = "", showModal: Bool = false, showClearButton: Bool = false, offSetY: CGFloat = 1000, popupText: String = "") {
        self.status = status
        self.statusInput = statusInput
        self.isModalShowing = showModal
        self.isClearButtonShowing = showClearButton
        self.offSetY = offSetY
        self.popupText = popupText
    }
    
    func openModalButtonTapped() {
        isModalShowing = true
    }
    
    func closeModalButtonTapped() {
        isModalShowing = false
    }
    
    func clearStatusInputButtonTapped() {
        statusInput = ""
        isClearButtonShowing = false
        popupText = "Status Cleared"
        saveOrClearPopupAppears()
    }
    
    func clearStatusInputTextFieldTapped() {
        statusInput = ""
        isClearButtonShowing = false
        isModalShowing = false
        popupText = "Status Cleared"
        saveOrClearPopupAppears()
    }
    
    func clearOrSaveButtonTapped() {
        if isClearButtonShowing {
            clearStatusInputTextFieldTapped()
        } else {
            saveButtonTapped()
        }
    }
    
    func saveButtonTapped() {
        if !statusInput.isEmpty {
            isClearButtonShowing = true
            isModalShowing = false
            popupText = "Set Status"
            saveOrClearPopupAppears()
        }
    }
    
    func saveOrClearPopupAppears() {
        offSetY = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.offSetY = 1000
        }
    }
    
}
