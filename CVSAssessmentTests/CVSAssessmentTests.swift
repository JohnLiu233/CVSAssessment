//
//  CVSAssessmentTests.swift
//  CVSAssessmentTests
//
//  Created by jiaxing liu on 12/2/24.
//

import XCTest
@testable import CVSAssessment

final class CVSAssessmentTests: XCTestCase {

    var flickrImage: FlickrImage?
    var viewModel: FlickrViewModel? = nil
    var mockService: MockFlickrAPIService!
    
    override func setUp() {
        super.setUp()
        mockService = MockFlickrAPIService()
        viewModel = FlickrViewModel(service: mockService)
        let descriptionHTML = """
        <p><a href="https://www.flickr.com/people/paulcottis/">Paul Cottis</a> posted a photo:</p>
        <p><a href="https://www.flickr.com/photos/paulcottis/54139627800/" title="Brazilian Porcupine - Black and White">
        <img src="https://live.staticflickr.com/65535/54139627800_15592300c0_m.jpg" width="240" height="153" alt="Brazilian Porcupine - Black and White" /></a></p>
        <p>El Dorado Lodge, Sierra Nevada de Santa Marta, Colombia</p>
        """
        flickrImage = FlickrImage(
            title: "Great Title",
            link: "https://www.flickr.com",
            media: FlickrMedia(mediaURL: "https://www.flickr.com/image.jpg"),
            description: descriptionHTML,
            published: "2024-11-27T03:10:10Z",
            author: "nobody@flickr.com (\"kevin palmer\")"
        )
    }
    
    override func tearDown() {
        flickrImage = nil
        mockService = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testParsedAuthor() {
        XCTAssertEqual(flickrImage?.parsedAuthor, "Kevin Palmer", "Parsed author should be 'Kevin Palmer'")
    }
    
    
    func testFormattedPublishedDate() {
        XCTAssertEqual(flickrImage?.formattedPublishedDate, "Nov 27, 2024 at 3:10 AM", "Published date should be formatted correctly.")
    }
    
    func testSuccessfulResponse() async throws {
        let mockJSON = """
                {
                    "items": [
                        {
                            "title": "Great Title",
                            "link": "https://www.flickr.com",
                            "media": { "m": "https://www.flickr.com/image.jpg" },
                            "description": "<p>Author posted a photo:</p><p>Photo description</p><p>El Dorado Lodge, Sierra Nevada de Santa Marta, Colombia</p>",
                            "published": "2024-11-27T03:10:10Z",
                            "author": "nobody@flickr.com (\\\"kevin palmer\\\")"
                        }
                    ]
                }
                """
        mockService.mockData = mockJSON.data(using: .utf8)
        mockService.mockResponseCode = 200
        
        let result = try await viewModel?.getImages(url: "https://www.flickr.com")
        XCTAssertEqual(result?.items.count, 1, "The mock response should contain 1 item.")
        XCTAssertEqual(result?.items.first?.title, "Great Title", "The title should match the mock data.")
    }
}
