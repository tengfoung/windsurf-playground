import XCTest
@testable import BOS

class NetworkingServiceTests: XCTestCase {
    
    var mockService: MockNetworkingService!
    var realService: RealNetworkingService!
    var urlSession: URLSession!
    var testURL: URL!
    
    override func setUp() {
        super.setUp()
        mockService = MockNetworkingService()
        
        // Setup URLSession with mock configuration
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)
        
        realService = RealNetworkingService(session: urlSession)
        testURL = URL(string: "https://api.example.com")!
    }
    
    override func tearDown() {
        mockService = nil
        realService = nil
        urlSession = nil
        testURL = nil
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }
    
    // MARK: - MockNetworkingService Tests
    
    func testMockSearchInsights() {
        let expectation = self.expectation(description: "Search insights")
        
        mockService.searchInsights(query: "test") { result in
            switch result {
            case .success(let insights):
                XCTAssertFalse(insights.isEmpty, "Should return non-empty array of insights")
            case .failure(let error):
                XCTFail("Search failed with error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testMockFetchTopPicks() {
        let expectation = self.expectation(description: "Fetch top picks")
        
        mockService.fetchTopPicks { result in
            switch result {
            case .success(let insights):
                XCTAssertFalse(insights.isEmpty, "Should return non-empty array of top picks")
            case .failure(let error):
                XCTFail("Fetch top picks failed with error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    // MARK: - RealNetworkingService Tests
    
    func testRealSearchInsightsSuccess() {
        let expectation = self.expectation(description: "Search insights success")
        
        // Mock response data
        let mockInsight = Insight(
            id: "test123",
            title: "Test Insight",
            hook: "Test hook",
            description: "Test description",
            date: "2023-01-01",
            tags: ["test", "unit"],
            imageUrl: nil,
            hasVideo: false,
            videoUrl: nil,
            category: "Test",
            company: "Test Co",
            indicators: nil
        )
        
        let response = SearchResponse(results: [mockInsight])
        let jsonData = try! JSONEncoder().encode(response)
        
        // Set up mock handler
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: self.testURL,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            return (response, jsonData)
        }
        
        realService.searchInsights(query: "test") { result in
            switch result {
            case .success(let insights):
                XCTAssertEqual(insights.count, 1)
                XCTAssertEqual(insights[0].id, "test123")
            case .failure(let error):
                XCTFail("Expected success, got \(error) instead")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testRealSearchInsightsInvalidURL() {
        let expectation = self.expectation(description: "Search insights invalid URL")
        
        // Create a service with an invalid base URL
        let invalidService = RealNetworkingService(
            baseURL: "",
            session: urlSession
        )
        
        invalidService.searchInsights(query: "test") { result in
            switch result {
            case .success:
                XCTFail("Expected invalid URL error")
            case .failure(let error):
                if case .invalidURL = error {
                    // Success
                } else {
                    XCTFail("Expected invalidURL error, got \(error) instead")
                }
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testRealSearchInsightsNetworkError() {
        let expectation = self.expectation(description: "Search insights network error")
        
        // Set up mock handler to return network error
        MockURLProtocol.requestHandler = { request in
            throw NSError(domain: "NSURLErrorDomain", code: -1009, userInfo: nil)
        }
        
        realService.searchInsights(query: "test") { result in
            switch result {
            case .success:
                XCTFail("Expected network error")
            case .failure(let error):
                if case .requestFailed = error {
                    // Success
                } else {
                    XCTFail("Expected requestFailed error, got \(error) instead")
                }
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testRealSearchInsightsInvalidResponse() {
        let expectation = self.expectation(description: "Search insights invalid response")
        
        // Set up mock handler to return invalid response (no data)
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: self.testURL,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            return (response, Data())
        }
        
        realService.searchInsights(query: "test") { result in
            switch result {
            case .success:
                XCTFail("Expected no data error")
            case .failure(let error):
                if case .noData = error {
                    // Success
                } else {
                    XCTFail("Expected noData error, got \(error) instead")
                }
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
}

// MARK: - Mock URLProtocol

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            client?.urlProtocol(self, didFailWithError: NSError(domain: "", code: 0, userInfo: [:]))
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}
