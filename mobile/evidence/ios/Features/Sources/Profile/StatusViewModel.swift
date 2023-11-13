//
//  StatusViewModel.swift
//  Evidence
//
//  Created by Cris Messias on 09/11/23.
//

import SwiftUI
import Models

public class StatusViewModel: ObservableObject {
    @Published private(set) var currentState: Profile = .active
    @Published private(set) var showModal = false
    @Published var statusInput: String = ""
    @Published private(set) var showAlert = false
    @Published private(set) var isButtonSaveTapped = false
    @Published private(set) var isClearButtonShowing = false
    
    public init(currentState: Profile = .active, showModal: Bool = false, statusInput: String = "", showAlert: Bool = false, isButtonSaveTapped: Bool = false, isClearButtonShowing: Bool = false) {
        self.currentState = currentState
        self.showModal = showModal
        self.statusInput = statusInput
        self.showAlert = showAlert
        self.isButtonSaveTapped = isButtonSaveTapped
        self.isClearButtonShowing = isClearButtonShowing
    }
    
    func isModalShowing() { 
        showModal.toggle()
    }
    
    func saveStatusButton() {
        if statusInput.isEmpty {
            showModal = true
        } else {
            showModal = false
        }
    }
    
    func toggleButton() {
        isClearButtonShowing.toggle()
    }
    
    func clearStatus() {
        statusInput = ""
    }
    
    func isAlertShowing() {
        showAlert = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showAlert = false
        }
    }
}

