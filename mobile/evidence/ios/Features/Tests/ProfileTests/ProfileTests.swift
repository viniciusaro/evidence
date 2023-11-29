////
////  ProfileTests.swift
////  
////
////  Created by Cris Messias on 12/11/23.
////
//
//import XCTest
//@testable import Profile
//@testable import Models
//
//final class ProfileTests: XCTestCase {
// 
//    func testStatusInputButtonTrue() {
//        let model = StatusViewModel()
//        model.statusInputButtonTapped()
//        XCTAssertTrue(model.isModalShowing)
//    }
//    
//    func testCloseModalButtonFalse() {
//        let model = StatusViewModel()
//        model.closeModalButtonTapped()
//        XCTAssertFalse(model.isModalShowing)
//    }
//    
//    func testClearStatusInputButtonSuccess() {
//        let model = StatusViewModel()
//        model.statusInput = "Some input"
//        model.clearStatusInputButtonTapped()
//        XCTAssertTrue(model.statusInput.isEmpty)
//        XCTAssertFalse(model.isClearButtonShowing)
//    }
//    
//    func testClearStatusInputTextFieldSuccess() {
//        let model = StatusViewModel()
//        model.statusInput = "Some input"
//        model.clearStatusInputTextFieldTapped()
//        XCTAssertTrue(model.statusInput.isEmpty)
//        XCTAssertFalse(model.isClearButtonShowing)
//    }
//    
//    func testSaveButtonNotEmptyStatusInput() {
//        let model = StatusViewModel()
//        model.statusInput = "Some input"
//        model.saveButtonTapped()
//<<<<<<< HEAD
//        XCTAssertTrue(model.isClearButtonShowing)
//        XCTAssertFalse(model.showModal)
//    }
//
//    func testpopupSaveOrClearActionsAppearsAndDisappears() {
//        let model = StatusViewModel()
//        model.popupSaveOrClearActions()
//        XCTAssertTrue(model.offSetY == 0)
//        let expectation = XCTestExpectation(description: "Wait for offSety to be set to equal to 1000")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            XCTAssertTrue(model.offSetY == 1000)
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 2)
//=======
//        XCTAssertTrue(model.isAlertShowing)
//        XCTAssertTrue(model.isClearButtonShowing)
//        XCTAssertFalse(model.isModalShowing)
//>>>>>>> main
//    }
//}
