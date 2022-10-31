/*
* Copyright (c) 2022 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import XCTest
import AppAuth
import OpenIDConnect
import OHHTTPStubs
import OHHTTPStubsSwift

final class OpenIDConnectTests: XCTestCase {

	private var sut: OpenIDConnectManager!
	
	override func setUp() {
		
		super.setUp()
	
		sut = OpenIDConnectManager()
	}
	
	override func tearDown() {
		
		super.tearDown()
		HTTPStubs.removeAllStubs()
	}
	
	
	func test_discovery_noInternet() {
		
		// Given
		let config = TestConfig()
		stub(condition: isHost("example.com")) { request in
			let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue)
			return HTTPStubsResponse(error: notConnectedError)
		}
		let exp = expectation(description: "test_discovery_noInternet")
		
		// When
		sut.requestAccessToken(issuerConfiguration: config, presentingViewController: nil) { _ in
			
			// Then
			XCTFail("requestAccessToken should not return with success, there is a no internet error")
			exp.fulfill()
		} onError: { error in
			XCTAssertNotNil(error)
			if let nsError = error as? NSError {
				XCTAssertEqual(nsError.code, OIDErrorCode.networkError.rawValue)
			}
			exp.fulfill()
		}
		waitForExpectations(timeout: 3)
	}
}

final class TestConfig: OpenIDConnectConfiguration {
	
	var issuerUrl: URL { return URL(string: "https://example.com")!}
	var clientId: String { return "test" }
	var redirectUri: URL { return URL(string: "https://app.com/app/auth")!}
}
