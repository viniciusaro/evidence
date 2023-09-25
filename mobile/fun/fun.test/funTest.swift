import XCTest
import fun

final class funTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCircleAreaWithZeroRadius() throws {
        XCTAssertEqual(circleArea(0), 0)
    }
    
    func testCircleAreaWithNegativeRadius() throws {
        XCTAssertEqual(circleArea(-1), 0)
    }
    
    func testCircleAreaWithPositiveRadius() throws {
        XCTAssertEqual(circleArea(1), Double.pi)
    }
}
