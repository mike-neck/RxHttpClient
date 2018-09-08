import XCTest

protocol Executable {

    associatedtype TestSuite = Self where Self: XCTestCase

    static var allTests: [(String, (TestSuite) -> () -> ())] { get }
}
