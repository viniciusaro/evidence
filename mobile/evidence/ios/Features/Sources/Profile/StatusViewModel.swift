//
//  StatusViewModel.swift
//  Evidence
//
//  Created by Cris Messias on 09/11/23.
//

import SwiftUI
import Models

public class StatusViewModel: ObservableObject {
    @Published private(set) var status: Profile = .active
    @Published var statusInput: String = ""
    @Published private(set) var showModal = false
    @Published private(set) var showAlert = false
    @Published private(set) var showClearButton = false
    
    public init(currentState: Profile = .active, showModal: Bool = false, statusInput: String = "", showAlert: Bool = false,  isClearButtonShowing: Bool = false) {
        self.status = currentState
        self.showModal = showModal
        self.statusInput = statusInput
        self.showAlert = showAlert
        self.showClearButton = isClearButtonShowing
    }
    
    func statusInputButtonTapped() {
        showModal = true
    }
    
    func modalCloseButtonTapped() {
        showModal = false
    }
    
    func clearStatusInputButtonTapped() {
        statusInput = ""
        showClearButton = false
        isAlertShowing()
    }
    
    func clearStatusInputTextField() {
        statusInput = ""
        showClearButton = false
    }
    
    func saveButtonTapped() {
        if !statusInput.isEmpty {
            isAlertShowing()
            showClearButton = true
            showModal = false
        } 
    }
    
    func isAlertShowing() {
        showAlert = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.showAlert = false
        }
    }
    
}

