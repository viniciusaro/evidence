//
//  StatusViewModel.swift
//  Evidence
//
//  Created by Cris Messias on 09/11/23.
//

import SwiftUI
import Models
import Leaf

public class StatusViewModel: ObservableObject {
    @Published private(set) var status: Profile
    @Published private(set) var offSetY: CGFloat
    @Published private(set) var popupState: AlertState
    @Published var setStatusViewModel: SetStatusViewModel?
    @Published var statusInput: String {
        didSet {
            if statusInput.isEmpty {
                popupState = .clear
                offSetY = 1000
                saveOrClearPopupAppears()
            } else {
                popupState = .save
                offSetY = 0
                saveOrClearPopupAppears()
            }
        }
    }

    public init(
        status: Profile = .active,
        offSetY: CGFloat = 1000,
        popupState: AlertState = .clear,
        setStatusViewModel: SetStatusViewModel? = nil,
        statusInput: String = ""
    ) {
        self.status = status
        self.offSetY = offSetY
        self.popupState = popupState
        self.setStatusViewModel = setStatusViewModel
        self.statusInput = statusInput
    }

    func openModalButtonTapped() {
        setStatusViewModel = SetStatusViewModel(statusInput: statusInput)
        setStatusViewModel?.delegateSaveButtonTapped = { newStatus in
            self.statusInput = newStatus
            self.setStatusViewModel = nil
        }
        setStatusViewModel?.delegateCloseButtonTapped = {
            self.setStatusViewModel = nil
        }
    }

    func closeModalButtonTapped() {
        setStatusViewModel = nil
    }

    func clearStatusInputButtonTapped() {
        statusInput = ""
    }

    func saveOrClearPopupAppears() {
        offSetY = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.offSetY = 1000
        }
    }
}
