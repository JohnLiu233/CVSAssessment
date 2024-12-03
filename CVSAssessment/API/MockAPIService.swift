//
//  MockAPIService.swift
//  CVSAssessment
//
//  Created by jiaxing liu on 12/2/24.
//

import Foundation

final class MockFlickrAPIService: FlickrAPIServiceProtocol {
    var error: FlickrAPIError?
    var mockData: Data?
    var mockResponseCode: Int?

    func getFlickrData<T: Decodable>(urlString: String, dataType: T.Type) async throws -> T {
        if let responseCode = mockResponseCode, !(200..<300).contains(responseCode) {
            throw FlickrAPIError.badResponse(statusCode: responseCode)
        }
    
        guard let mockData = mockData else {
            throw FlickrAPIError.badRequest
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: mockData)
            return decodedData
        } catch {
            throw FlickrAPIError.decoderError
        }
    }
}
