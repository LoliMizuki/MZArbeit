import XCTest
@testable import MZArbeit

final class MZArbeitTests: XCTestCase {
    
    func testCSVParser() throws {
        guard
            let csvFileURL = Bundle.module.url(forResource: "test", withExtension: "csv"),
            let csvContent = try? String(contentsOf: csvFileURL) else {
            assertionFailure("fail to load test file"); return
        }
    
        let parser = MZArbeit.CSVParser(csvContent: csvContent)
        let itemsByLine = parser.itemsByLine()
        
        guard let items = itemsByLine.first else {
            assertionFailure("fail to parsing csv content"); return
        }
        
        
        print("\(items.joined(separator: ", "))")
        assert(
            items[0] == "aaaa" &&
            items[1] == "bbbb" &&
            items[2] == "cccc",
            "items.value is incorrect"
        )
    }
}
