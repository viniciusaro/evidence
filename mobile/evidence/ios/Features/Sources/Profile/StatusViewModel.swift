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
    @Published private(set) var isModalShowing = false
    @Published private(set) var isAlertShowing = false
    @Published private(set) var isClearButtonShowing = false
    
    public init(status: Profile = .active, isModalShowing: Bool = false, statusInput: String = "", isAlertShowing: Bool = false,  isClearButtonShowing: Bool = false) {
        self.status = status
        self.isModalShowing = isModalShowing
        self.statusInput = statusInput
        self.isAlertShowing = isAlertShowing
        self.isClearButtonShowing = isClearButtonShowing
    }
    
    func statusInputButtonTapped() {
        isModalShowing = true
    }
    
    func CloseModalButtonTapped() {
        isModalShowing = false
    }
    
    func clearStatusInputButtonTapped() {
        statusInput = ""
        isClearButtonShowing = false
        alertaButtonTapped()
    }
    
    func clearStatusInputTextFieldTapped() {
        statusInput = ""
        isClearButtonShowing = false
    }
    
    private func showClearButtonAndCloseModal() {
        isClearButtonShowing = true
        isModalShowing = false
    }
    
    func saveButtonTapped() {
        if !statusInput.isEmpty {
            alertaButtonTapped()
            showClearButtonAndCloseModal()
        }
    }
    
    func clearOrSaveButtonTapped() {
        if isClearButtonShowing {
            clearStatusInputTextFieldTapped()
        } else {
            saveButtonTapped()
        }
    }
    
    private func alertaButtonTapped() {
        isAlertShowing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.isAlertShowing = false
        }
    }
    
}
